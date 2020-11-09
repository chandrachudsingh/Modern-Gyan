<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Student Register</title>
</head>

<body>

    <%
        String name = request.getParameter("txStudentName");
        String age = request.getParameter("txAge");
        String dob = request.getParameter("DOB");
        String gender = request.getParameter("rbGender");
        String college = request.getParameter("txCollege");
        String city = request.getParameter("txCity");
        String country = request.getParameter("txCountry");
        String email = request.getParameter("txEmail");
        String branch = request.getParameter("cbBranch");
        String proof = request.getParameter("cbProof");
        String proof_doc = request.getParameter("fileProof_Img");
        String userid = request.getParameter("txUser");
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
			stmt.executeUpdate("Create table if not exists StudentTb(student_id int auto_increment primary key," 
					+ "name varchar(255), age int, DOB date, gender varchar(20), email varchar(255), college varchar(255),"
                    + "city varchar(255), country varchar(255), branch_name varchar(255), proof varchar(255), proof_doc varchar(255),"
                    + "userid varchar(255) unique, password varchar(255))");

            PreparedStatement pstmt=con.prepareStatement("INSERT INTO StudentTb(name, age, DOB, gender, email, college,"
                    + "city, country, branch_name, proof, proof_doc, userid, password) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)");
			pstmt.setString(1, name);
			pstmt.setString(2, age);

			java.sql.Date dt= Date.valueOf(dob);
			pstmt.setDate(3, dt);
			pstmt.setString(4, gender);
			pstmt.setString(5, email);
			pstmt.setString(6, college);
			pstmt.setString(7, city);
			pstmt.setString(8, country);
			pstmt.setString(9, branch);
			pstmt.setString(10, proof);
			pstmt.setString(11, proof_doc);
			pstmt.setString(12, userid);
			pstmt.setString(13, password);
			pstmt.executeUpdate();

			String tb = userid + "_courses_tb";
			pstmt.executeUpdate("create table if not exists "+tb+" (course_no int auto_increment primary key, course_code varchar(255),"
				+ "course_type varchar(255), faculty_code varchar(255), platform varchar(255), slot varchar(255), duration int, start_date date, end_date date)");

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

		application.setAttribute("status", "success");
		response.sendRedirect("../LoginPage.jsp");
    %>

</body>
</html>