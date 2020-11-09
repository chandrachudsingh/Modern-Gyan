<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Topic insert</title>
</head>

<body>

    <%
        String topic_code = request.getParameter("txTopicCode");
        String topic_name = request.getParameter("txTopicName");
        String topic_duration = request.getParameter("txTopicDuration");
        String subject_code = request.getParameter("cbSubCode");
		String fees = request.getParameter("txFees");

        try 
		{
			Class.forName("com.mysql.jdbc.Driver");   //to load driver class
			Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306", "root", "");
											//to build connection between Java and database 
			Statement stmt=con.createStatement();  //create statement class object
			stmt.executeUpdate("Create database if not exists Modern_Gyan_Db");   
					//"if not exists" used because of database not created multiple times(error)
			
			stmt.execute("Use Modern_Gyan_Db");
			stmt.executeUpdate("Create table if not exists TopicTb(topic_id int auto_increment primary key, topic_code varchar(50) unique,"
					+ " topic_name varchar(50), subject_code varchar(50), fees varchar(10), duration_hrs int, student_enrolled int default 0)");

            PreparedStatement pstmt=con.prepareStatement("INSERT INTO TopicTb(topic_code,topic_name,subject_code,fees,duration_hrs)"
				+ " VALUES (?,?,?,?,?)");
			pstmt.setString(1, topic_code);
			pstmt.setString(2, topic_name);
			pstmt.setString(3, subject_code);
			pstmt.setString(4, fees);
			pstmt.setString(5, topic_duration);
			pstmt.executeUpdate();

            con.close();
		}
		catch (ClassNotFoundException e) 
		{
			out.println("ClassNotFoundException caught: "+e.getMessage());
		}

		application.setAttribute("status", "success");
		response.sendRedirect("TopicInsert.jsp");
    %>

</body>
</html>