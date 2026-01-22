<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome - DemocraTech</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #ffffff;
            color: #333;
            line-height: 1.6;
        }

        .header {
            background-color: #003366;
            color: white;
            padding: 1rem 3rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .header-left {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .header-left img {
            width: 50px;
            height: 50px;
            object-fit: contain;
        }

        .header-left h1 {
            font-size: 1.8rem;
            font-weight: 600;
        }

        .header-right {
            display: flex;
            align-items: center;
            gap: 1.5rem;
        }

        .header-btn {
            color: white;
            text-decoration: none;
            font-size: 1rem;
            font-weight: 500;
            padding: 0.5rem 1.5rem;
            border-radius: 4px;
            transition: all 0.3s;
        }

        .header-btn:hover {
            background-color: rgba(255, 255, 255, 0.1);
        }

        .btn-login {
            background-color: #FFB200;
            color: #003366;
        }

        .btn-login:hover {
            background-color: #ffc933;
        }

        .hero-section {
            position: relative;
            width: 100%;
            height: 400px;
            overflow: hidden;
        }

        .hero-section img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            object-position: center;
        }

        .hero-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(to right, rgba(0, 51, 102, 0.8), rgba(0, 51, 102, 0.4));
            display: flex;
            align-items: center;
            padding: 0 3rem;
        }

        .hero-content {
            color: white;
            max-width: 600px;
        }

        .hero-content h2 {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            font-weight: 700;
        }

        .hero-content p {
            font-size: 1.2rem;
            margin-bottom: 2rem;
            line-height: 1.8;
        }

        .hero-btn {
            background-color: #FFB200;
            color: #003366;
            padding: 1rem 2.5rem;
            border: none;
            border-radius: 4px;
            font-size: 1.1rem;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
            cursor: pointer;
            transition: all 0.3s;
        }

        .hero-btn:hover {
            background-color: #ffc933;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 178, 0, 0.4);
        }

        .features-section {
            padding: 4rem 3rem;
            background-color: #f8f9fa;
        }

        .features-section h2 {
            text-align: center;
            color: #003366;
            font-size: 2.2rem;
            margin-bottom: 3.5rem;
            font-weight: 600;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 2.5rem;
            max-width: 1100px;
            margin: 0 auto;
        }

        .feature-card {
            background: white;
            padding: 2.5rem 2rem;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            transition: all 0.3s;
            text-align: center;
            border-top: 4px solid #003366;
            position: relative;
            overflow: hidden;
        }

        .feature-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(to right, #003366, #FFB200);
            transform: scaleX(0);
            transition: transform 0.3s;
        }

        .feature-card:hover::before {
            transform: scaleX(1);
        }

        .feature-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 8px 24px rgba(0,0,0,0.15);
        }

        .feature-card h3 {
            color: #003366;
            font-size: 1.5rem;
            margin-bottom: 1rem;
            font-weight: 600;
        }

        .feature-card p {
            color: #6c757d;
            font-size: 1rem;
            line-height: 1.7;
        }

        .about-section {
            padding: 4rem 3rem;
            background-color: #ffffff;
        }

        .about-content {
            max-width: 900px;
            margin: 0 auto;
            text-align: center;
        }

        .about-content h2 {
            color: #003366;
            font-size: 2rem;
            margin-bottom: 1.5rem;
            font-weight: 600;
        }

        .about-content p {
            color: #333;
            font-size: 1.1rem;
            line-height: 1.8;
            margin-bottom: 1rem;
        }

        .footer {
            background-color: #003366;
            color: white;
            padding: 1.5rem 3rem;
            text-align: center;
        }

        .footer p {
            margin-bottom: 0.3rem;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-left">
            <img src="images/DT_logo.png" alt="DemocraTech Logo">
            <h1>DemocraTech</h1>
        </div>
        <div class="header-right">
            <a href="login.jsp" class="header-btn btn-login">Login</a>
            <a href="register.jsp" class="header-btn">Register</a>
        </div>
    </div>

    <div class="hero-section">
        <img src="images/uitm.png" alt="UiTM Campus">
        <div class="hero-overlay">
            <div class="hero-content">
                <h2>Welcome to DemocraTech</h2>
                <p>Your trusted platform for secure, transparent, and democratic student elections at UiTM. Vote with confidence, lead with integrity.</p>
                <a href="login.jsp" class="hero-btn">Get Started</a>
            </div>
        </div>
    </div>

    <div class="features-section">
        <h2>Why Choose DemocraTech?</h2>
        <div class="features-grid">
             <div class="feature-card">
            <h3>Secure Voting</h3>
                <p>Advanced security measures ensure your vote is protected and anonymous throughout the election process.</p>
            </div>
            <div class="feature-card">
                <h3>Real-time Results</h3>
                <p>Access live election results and detailed analytics immediately after voting closes.</p>
            </div>
            <div class="feature-card">
                <h3>Transparent Process</h3>
                <p>Complete transparency from candidate registration to final results declaration
                <p>User-friendly interface designed for students.</p>
            </div>
        </div>
    </div>

    <div class="about-section">
        <div class="about-content">
            <h2>About DemocraTech</h2>
            <p>DemocraTech is a comprehensive student election management system developed for Universiti Teknologi MARA (UiTM). Our platform modernizes the democratic process by providing a secure, efficient, and transparent voting experience for all students.</p>
            <p>Built with cutting-edge technology and designed with the student experience in mind, DemocraTech ensures every vote counts and every voice is heard.</p>
        </div>
    </div>

    <div class="footer">
        <p><strong>© 2025 DemocraTech | Student Election System</strong></p>
        <p>Universiti Teknologi MARA</p>
    </div>
</body>
</html>
