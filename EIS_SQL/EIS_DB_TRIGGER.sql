-- TRIGGER TO VALIDATE UNIQUE AND VALID EMAIL 
CREATE OR REPLACE FUNCTION validate_email()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT (NEW.E_MAIL_ADDRESS ~ '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$') THEN
        RAISE EXCEPTION 'Invalid Email: %', NEW.E_MAIL_ADDRESS;
    END IF;

    IF TG_TABLE_NAME = 'applicant' THEN
        IF EXISTS (
            SELECT 1 
            FROM PUBLIC.APPLICANT 
            WHERE E_MAIL_ADDRESS = NEW.E_MAIL_ADDRESS
              AND APPLICANT_ID != NEW.APPLICANT_ID -- Đảm bảo không tự so sánh
        ) THEN
            RAISE EXCEPTION 'Email already exists in the APPLICANT table: %', NEW.E_MAIL_ADDRESS;
        END IF;
    ELSIF TG_TABLE_NAME = 'employee' THEN
        IF EXISTS (
            SELECT 1 
            FROM PUBLIC.EMPLOYEE 
            WHERE E_MAIL_ADDRESS = NEW.E_MAIL_ADDRESS
              AND EMPLOYEE_ID != NEW.EMPLOYEE_ID -- Đảm bảo không tự so sánh
        ) THEN
            RAISE EXCEPTION 'Email already exists in the EMPLOYEE table: %', NEW.E_MAIL_ADDRESS;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

---CREATE TRIGGER FOR APLLICANT TABLE 
CREATE TRIGGER trigger_validate_applicant_email
BEFORE INSERT OR UPDATE ON APPLICANT
FOR EACH ROW
EXECUTE FUNCTION validate_email();

---CREATE TRIGGER FOR EMPLOYEE TABLE
CREATE TRIGGER trg_validate_employee_email
BEFORE INSERT OR UPDATE ON EMPLOYEE
FOR EACH ROW
EXECUTE FUNCTION validate_email();

-------------------------------------------------------------
---TRIGGER TO VALIDATE PHONE_NUMBER
CREATE OR REPLACE FUNCTION validate_phone_number()
RETURNS TRIGGER AS $$
BEGIN
    -- Regex kiểm tra số điện thoại hợp lệ
    IF NOT (NEW.PHONE_NUMBER ~ '^0(32|33|34|35|36|37|38|39|96|97|98|86|83|84|85|81|82|88|91|94|70|79|77|76|78|90|93|89|56|58|92|59|99)[0-9]{7}$') THEN
        RAISE EXCEPTION 'Invalid phone number format: %', NEW.PHONE_NUMBER;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

---CREATE TRIGGER FOR EMPLOYEE TABLE
CREATE TRIGGER check_employee_phone_number
BEFORE INSERT OR UPDATE ON EMPLOYEE
FOR EACH ROW
EXECUTE FUNCTION validate_phone_number();

---CREATE TRIGGER FOR APPLICANT TABLE
CREATE TRIGGER check_apllicant_phone_number
BEFORE INSERT OR UPDATE ON APPLICANT
FOR EACH ROW
EXECUTE FUNCTION validate_phone_number();

--------------------------------------------------------
---TRIGGER TO VALIDATE TIME
CREATE OR REPLACE FUNCTION validate_job_description_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.END_TIME < NOW() THEN
        RAISE EXCEPTION 'END_TIME must be in the future: %', NEW.END_TIME;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
--
CREATE TRIGGER validate_job_description_end_time
BEFORE INSERT OR UPDATE ON job_description
FOR EACH ROW
EXECUTE FUNCTION validate_job_description_timestamp();

--FOR INTERVIEW
CREATE OR REPLACE FUNCTION validate_interview_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.SCHEDULE_DATE < NOW() THEN
        RAISE EXCEPTION 'SCHEDULE_DATE must be in the future: %', NEW.SCHEDULE_DATE;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 
CREATE TRIGGER validate_interview_schedule_date
BEFORE INSERT OR UPDATE ON interview
FOR EACH ROW
EXECUTE FUNCTION validate_interview_timestamp();

---CREATE TRIGGER FOR JOB_DESCRIPTION
CREATE TRIGGER check_job_description_end_time
BEFORE INSERT OR UPDATE ON JOB_DESCRIPTION
FOR EACH ROW
EXECUTE FUNCTION validate_timestamps();

----------------------------------------------
---TRIGGER VALIDATE PARTIAL_EVALUATION VALUE
CREATE OR REPLACE FUNCTION validate_partial_evaluation()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.partial_evaluation < 0 OR NEW.partial_evaluation > 100 THEN
        RAISE EXCEPTION 'Partial evaluation must be between 0 and 100: %', NEW.partial_evaluation;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_partial_evaluation
BEFORE INSERT OR UPDATE ON INTERVIEW_DETAIL
FOR EACH ROW
EXECUTE FUNCTION validate_partial_evaluation();

--------------------------------
---TRIGGER CALCULATE AVERAGE EVALUATION VALUE
CREATE OR REPLACE FUNCTION update_interview_evaluation()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE INTERVIEW
    SET EVALUATION = (
        SELECT AVG(partial_evaluation)
        FROM interview_detail
        WHERE interview_id = NEW.interview_id
    )
    WHERE INTERVIEW_ID = NEW.interview_id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

---CREATE TRIGGER UPDATE EVALUATION
CREATE TRIGGER update_evaluation_trigger
AFTER INSERT OR UPDATE OR DELETE
ON interview_detail
FOR EACH ROW
EXECUTE FUNCTION update_interview_evaluation();



--------------------------------------
---FUNCTION VALIDATE INTERVIEW SCHEDULE
--FOR APPLICANT
CREATE OR REPLACE FUNCTION check_interview_schedule()
RETURNS TRIGGER AS $$
BEGIN
    -- Only check for conflicts if SCHEDULE_DATE is modified
    IF NEW.SCHEDULE_DATE <> OLD.SCHEDULE_DATE THEN
        IF EXISTS (
            SELECT 1
            FROM INTERVIEW
            WHERE APPLICATION_ID IN (
                SELECT APPLICATION_ID
                FROM APPLICATION
                WHERE APPLICANT_ID = (
                    SELECT APPLICANT_ID
                    FROM APPLICATION
                    WHERE APPLICATION_ID = NEW.APPLICATION_ID
                )
            )
            AND SCHEDULE_DATE = NEW.SCHEDULE_DATE
        ) THEN
            RAISE EXCEPTION 'Applicant already has an interview scheduled at this time: %', NEW.SCHEDULE_DATE;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


--FOR INTERVIEWER
CREATE OR REPLACE FUNCTION check_interviewer_schedule()
RETURNS TRIGGER AS $$
BEGIN
    -- Only check for conflicts if SCHEDULE_DATE is modified
    IF NEW.SCHEDULE_DATE <> OLD.SCHEDULE_DATE THEN
        IF EXISTS (
            SELECT 1
            FROM INTERVIEW_DETAIL id
            JOIN INTERVIEW i ON id.INTERVIEW_ID = i.INTERVIEW_ID
            WHERE id.INTERVIEWER_ID IN (
                SELECT INTERVIEWER_ID
                FROM INTERVIEW_DETAIL
                WHERE INTERVIEW_ID = NEW.INTERVIEW_ID
            )
            AND i.SCHEDULE_DATE = NEW.SCHEDULE_DATE
        ) THEN
            RAISE EXCEPTION 'Interviewer already has an interview scheduled at this time: %', NEW.SCHEDULE_DATE;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


----
--- PROCEDURE UPDATE SCHEDULE DATE IN INTERVIEW TABLES
CREATE OR REPLACE PROCEDURE update_schedule_date(interview_id_input INT, new_schedule_date TIMESTAMP) 
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE INTERVIEW
    SET SCHEDULE_DATE = new_schedule_date
    WHERE INTERVIEW_ID = interview_id_input;

    RAISE NOTICE 'New interview schedule has been updated: %', new_schedule_date;
END;
$$;
----------
---CALL update_schedule_date(1, '2025-01-25 10:00:00');

---SELECT  * FROM INTERVIEW

--- PROCEDURE UPDATE STATUS FOR APPLICATION TABLE 
CREATE OR REPLACE PROCEDURE update_application_status(
    application_id_input INT,
    new_application_status VARCHAR(30)
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE APPLICATION
    SET APPLICATION_STATUS = new_application_status
    WHERE APPLICATION_ID = application_id_input;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Application with ID % not found.', application_id_input;
    END IF;
    RAISE NOTICE 'Application status updated to: %', new_application_status;
END;
$$;

--- PROCEDURE UPDATE STATUS FOR INTERVIEW TABLE: 
CREATE OR REPLACE PROCEDURE update_interview_status(
    interview_id_input INT,
    new_interview_status VARCHAR(30)
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Update the INTERVIEW_STATUS field
    UPDATE INTERVIEW
    SET INTERVIEW_STATUS = new_interview_status
    WHERE INTERVIEW_ID = interview_id_input;

    -- Check if the update was successful
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Interview with ID % not found.', interview_id_input;
    END IF;

    -- Notify the successful update
    RAISE NOTICE 'Interview status updated to: %', new_interview_status;
END;
$$;

---
CREATE OR REPLACE FUNCTION check_schedule_conflict()
RETURNS TRIGGER AS $$
BEGIN
    -- Only check for conflicts if SCHEDULE_DATE is being modified
    IF TG_OP = 'UPDATE' AND NEW.SCHEDULE_DATE = OLD.SCHEDULE_DATE THEN
        RETURN NEW;
    END IF;

    -- Check if the applicant already has an interview at the same time
    IF EXISTS (
        SELECT 1
        FROM INTERVIEW
        WHERE APPLICATION_ID IN (
            SELECT APPLICATION_ID
            FROM APPLICATION
            WHERE APPLICANT_ID = (
                SELECT APPLICANT_ID
                FROM APPLICATION
                WHERE APPLICATION_ID = NEW.APPLICATION_ID
            )
        )
        AND SCHEDULE_DATE = NEW.SCHEDULE_DATE
    ) THEN
        RAISE EXCEPTION 'Applicant already has an interview scheduled at this time: %', NEW.SCHEDULE_DATE;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_schedule_conflict
BEFORE INSERT OR UPDATE ON INTERVIEW
FOR EACH ROW
EXECUTE FUNCTION check_schedule_conflict();
