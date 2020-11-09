<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Add Admin | Modern-Gyan</title>
</head>

<body>

    <%
        String name = request.getParameter("txName");
        String user = request.getParameter("txUser");
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
			stmt.executeUpdate("Create table if not exists AdminTb(Admin_id int auto_increment primary key, admin_name varchar(255)," 
                + "username varchar(255) unique, password varchar(255))");

            PreparedStatement pstmt=con.prepareStatement("INSERT INTO AdminTb(admin_name,username,password) VALUES (?,?,?)");
			pstmt.setString(1, name);
			pstmt.setString(2, user);
			pstmt.setString(3, password);
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
		response.sendRedirect("AddAdmin.jsp");
    %>
	
</body>
</html>