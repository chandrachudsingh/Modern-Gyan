<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Login Page</title>
</head>

<body>

    <%
        int c = 0;
        String usertype = request.getParameter("rbUserType");
        String userid = request.getParameter("txUsername");
        String password = request.getParameter("txPassword");

        if(usertype.equals("Student"))
        {
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
                    + "userid varchar(255), password varchar(255))");

                PreparedStatement pstmt=con.prepareStatement("SELECT COUNT(*) from StudentTb WHERE userid=? and password=?");
                pstmt.setString(1, userid);
                pstmt.setString(2, password);

                c = 0;
                ResultSet rs = pstmt.executeQuery();
                while(rs.next())
                    c=rs.getInt(1);

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
        }

        else
        {
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
					+ "faculty_code varchar(100), faculty_name varchar(255), DOB date, gender varchar(20),qualification varchar(255),"
                    + "experience varchar(255), address varchar(255), mobile varchar(20),email varchar(255)," 
                    + "curr_Profession varchar(255), faculty_img varchar(255), facultycode_img varchar(255))");

                PreparedStatement pstmt=con.prepareStatement("SELECT COUNT(*) from FacultyTb WHERE faculty_code=? and password=?");
                pstmt.setString(1, userid);
                pstmt.setString(2, password);

                c = 0;
                ResultSet rs = pstmt.executeQuery();
                while(rs.next())
                    c=rs.getInt(1);

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
        }

        if(c==1)
        {
            if(usertype.equals("Student"))
            {
                application.setAttribute("session_student", userid);
                response.sendRedirect("Student/StudentHome.jsp");
            }
            else
            {
                application.setAttribute("session_faculty", userid);
                response.sendRedirect("Faculty/FacultyHome.jsp");
            }
        }
        else
        {
            %><script>
                alert("Either username or password in incorrect!");
                window.history.go(-1);
            </script><%
        }
    %>

</body>
</html>