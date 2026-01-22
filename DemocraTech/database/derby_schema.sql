CREATE TABLE FACULTY (
    faculty_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    faculty_name VARCHAR(100) NOT NULL UNIQUE,
    faculty_code VARCHAR(20) NOT NULL UNIQUE
);


-- 2. STUDENT TABLE
CREATE TABLE STUDENT (
    student_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    faculty_id INT,
    CONSTRAINT fk_student_faculty FOREIGN KEY (faculty_id) REFERENCES FACULTY(faculty_id)
);

=
-- 3. ADMIN TABLE
CREATE TABLE ADMIN (
    admin_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    password VARCHAR(100) NOT NULL,
    faculty_id INT,
    CONSTRAINT fk_admin_faculty FOREIGN KEY (faculty_id) REFERENCES FACULTY(faculty_id)
);


-- 4. ELECTION TABLE
CREATE TABLE ELECTION (
    election_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    election_title VARCHAR(200) NOT NULL,
    election_description VARCHAR(1000),
    faculty_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'UPCOMING',
    total_votes INT DEFAULT 0,
    CONSTRAINT fk_election_faculty FOREIGN KEY (faculty_id) REFERENCES FACULTY(faculty_id),
    CONSTRAINT chk_election_status CHECK (status IN ('UPCOMING', 'ONGOING', 'COMPLETED', 'CANCELLED'))
);


-- 5. POSITION TABLE
CREATE TABLE POSITION (
    position_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    election_id INT NOT NULL,
    position_name VARCHAR(100) NOT NULL,
    display_order INT DEFAULT 0,
    CONSTRAINT fk_position_election FOREIGN KEY (election_id) REFERENCES ELECTION(election_id) ON DELETE CASCADE,
    CONSTRAINT uk_election_position UNIQUE (election_id, position_name)
);


-- 6. CANDIDATE TABLE
CREATE TABLE CANDIDATE (
    candidate_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    position_id INT NOT NULL,
    student_id INT NOT NULL,
    manifesto VARCHAR(2000) NOT NULL,
    status BOOLEAN,
    applied_at TIMESTAMP,
    reviewed_at TIMESTAMP,
    vote_count INT DEFAULT 0,
    vote_percentage DECIMAL(5,2) DEFAULT 0.00,
    CONSTRAINT fk_candidate_position FOREIGN KEY (position_id) REFERENCES POSITION(position_id) ON DELETE CASCADE,
    CONSTRAINT fk_candidate_student FOREIGN KEY (student_id) REFERENCES STUDENT(student_id),
    CONSTRAINT uk_position_student UNIQUE (position_id, student_id)
);


-- 7. VOTE TABLE
CREATE TABLE VOTE (
    vote_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    student_id INT NOT NULL,
    election_id INT NOT NULL,
    candidate_id INT,
    vote_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_vote_student FOREIGN KEY (student_id) REFERENCES STUDENT(student_id),
    CONSTRAINT fk_vote_election FOREIGN KEY (election_id) REFERENCES ELECTION(election_id),
    CONSTRAINT fk_vote_candidate FOREIGN KEY (candidate_id) REFERENCES CANDIDATE(candidate_id)
);


-- 8. RESULT TABLE
CREATE TABLE RESULT (
    result_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    election_id INT NOT NULL,
    candidate_id INT NOT NULL,
    total_votes INT,
    is_winner BOOLEAN,
    CONSTRAINT fk_result_election FOREIGN KEY (election_id) REFERENCES ELECTION(election_id),
    CONSTRAINT fk_result_candidate FOREIGN KEY (candidate_id) REFERENCES CANDIDATE(candidate_id)
);

