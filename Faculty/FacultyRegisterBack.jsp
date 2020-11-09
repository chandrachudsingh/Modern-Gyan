<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Faculty insert</title>
</head>

<body>

    <%
        String faculty_code = request.getParameter("txFacultyCode");
        String faculty_name = request.getParameter("txFacultyName");
        String dob = request.getParameter("DOB");
        String gender = request.getParameter("rbGender");
        String qualification = request.getParameter("tQual");
        String experience = request.getParameter("tExp");
        String address = request.getParameter("tAddress");
        String mobile = request.getParameter("txMobile");
        String email = request.getParameter("txEmail");
        String curr_prof = request.getParameter("tProf");
        String fac_img = "../Images/"+ request.getParameter("fileFac_Img");
        String code_img = "../Images/"+ request.getParameter("fileCode_Img");
        String password = request.getParameter("txPassword");

        try 
		{
			Class.forName("com.mysql.jdbc.Driver");   //to load driver class
			Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306", "root", "");
											//to build connection between Java and database 
			Statement stmt=con.createStatement();  //create statement class object
			stmt.executeUpdate("Create database if not exists Modern_Gyan_Db");   
					//"if not exists" used because of database not created multiple times(error)
			
			stmt.execute("Use Modern_Gyan_Db");
			stmt.executeUpdate("Create table if not exists FacultyTb(faculty_id int auto_increment primary key," 
					+ "faculty_code varchar(100) unique, faculty_name varchar(255), DOB date, gender varchar(20),qualification varchar(255),"
                    + "experience varchar(255), address varchar(255), mobile varchar(20),email varchar(255)," 
                    + "curr_Profession varchar(255), faculty_img varchar(255), facultycode_img varchar(255), password varchar(255))");

            PreparedStatement pstmt=con.prepareStatement("insert into FacultyTb(faculty_code,faculty_name,DOB,gender,qualification,"
            	+ "experience,address,mobile,email,curr_Profession,faculty_img,facultycode_img,password) values "
				+ "(?,?,?,?,?,?,?,?,?,?,?,?,?)");
			pstmt.setString(1, faculty_code);
			pstmt.setString(2, faculty_name);

			java.sql.Date dt= Date.valueOf(dob);
			pstmt.setDate(3, dt);
			pstmt.setString(4, gender);
			pstmt.setString(5, qualification);
			pstmt.setString(6, experience);
			pstmt.setString(7, address);
			pstmt.setString(8, mobile);
			pstmt.setString(9, email);
			pstmt.setString(10, curr_prof);
			pstmt.setString(11, fac_img);
			pstmt.setString(12, code_img);
			pstmt.setString(13, password);
			pstmt.executeUpdate();

			String tb = faculty_code + "_subjectcode_tb";
			pstmt.executeUpdate("create table if not exists "+tb+" (subject_id int auto_increment primary key, subject_code varchar(255) unique,"
				+ "	student_enrolled int default 0, rating float default 0, rating_count int default 0)");

			tb = faculty_code + "_timing_tb";
			pstmt.executeUpdate("create table if not exists "+tb+" (slot1 varchar(20), slot2 varchar(20), slot3 varchar(20),"
				+ "	slot4 varchar(20), slot5 varchar(20), slot6 varchar(20))");
				
			tb = faculty_code + "_platform_tb";
			pstmt.executeUpdate("create table if not exists "+tb+" (platform_id int auto_increment primary key, platform varchar(255) unique,"
			 	+ "	meeting_id varchar(255), meeting_password varchar(255))");
			
			tb = faculty_code + "_assignsubject_tb";
			pstmt.executeUpdate("create table if not exists "+tb+" (id int auto_increment primary key, platform_id int,slotno int, course_code varchar(255),"
			 	+ " meeting_id varchar(255), meeting_password varchar(255), student_enrolled int default 0, assign_date date, finish_date date)");

            con.close();
		}
		catch (ClassNotFoundException e) 
		{
			out.println("ClassNotFoundException caught: "+e.getMessage());
		}
		catch (SQLException e) 
		{
			out.println("SQLException caught: "+e.getMessage());
		}

		response.sendRedirect("FacultyPreferences.jsp");
    %>

</body>
</html>