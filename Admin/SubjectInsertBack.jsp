<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Subject insert</title>
</head>

<body>

    <%
        String sub_code = request.getParameter("txSubCode");
        String sub_name = request.getParameter("txSubName");
        String branch_code = request.getParameter("cbBranchCode");
        String fees = request.getParameter("txFees");
        String duration_hrs = request.getParameter("txDuration");

        try 
		{
			Class.forName("com.mysql.jdbc.Driver");   //to load driver class
			Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306", "root", "");
											//to build connection between Java and database 
			Statement stmt=con.createStatement();  //create statement class object
			stmt.executeUpdate("Create database if not exists Modern_Gyan_Db");   
					//"if not exists" used because of database not created multiple times(error)
			
			stmt.execute("Use Modern_Gyan_Db");
			stmt.executeUpdate("Create table if not exists SubjectTb(subject_id int auto_increment primary key, subject_code varchar(50) unique,"
					+ " subject_name varchar(50), branch_code varchar(50), fees varchar(100), duration_hrs int, student_enrolled int default 0)");

            PreparedStatement pstmt=con.prepareStatement("INSERT INTO SubjectTb(subject_code,subject_name,branch_code,fees,duration_hrs)"
				+" VALUES (?,?,?,?,?)");
			pstmt.setString(1, sub_code);
			pstmt.setString(2, sub_name);
			pstmt.setString(3, branch_code);
			pstmt.setString(4, fees);
			pstmt.setString(5, duration_hrs);
			pstmt.executeUpdate();

			String tb = sub_code + "_studentenrolled_tb"; 
			stmt.executeUpdate("Create table if not exists "+tb+"(student_enrolled int default 0)");

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
		response.sendRedirect("SubjectInsert.jsp");
    %>

</body>
</html>