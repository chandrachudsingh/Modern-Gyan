<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Branch insert</title>
</head>

<body>

    <%
        String branch_code = request.getParameter("txBranchCode");
        String branch_name = request.getParameter("txBranchName");

        try 
		{
			Class.forName("com.mysql.jdbc.Driver");   //to load driver class
			Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306", "root", "");
											//to build connection between Java and database 
			Statement stmt=con.createStatement();  //create statement class object
			stmt.executeUpdate("Create database if not exists Modern_Gyan_Db");   
					//"if not exists" used because of database not created multiple times(error)
			
			stmt.execute("Use Modern_Gyan_Db");
			stmt.executeUpdate("Create table if not exists BranchTb(branch_id int auto_increment primary key,"
					+ "branch_code varchar(50) unique, branch_name varchar(255) unique)");

			PreparedStatement pstmt=con.prepareStatement("INSERT INTO BranchTb(branch_code,branch_name) VALUES (?,?)");
			pstmt.setString(1, branch_code);
			pstmt.setString(2, branch_name);
			pstmt.executeUpdate();

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
		response.sendRedirect("BranchInsert.jsp");
    %>

</body>
</html>