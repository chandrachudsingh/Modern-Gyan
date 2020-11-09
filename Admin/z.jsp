<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*, java.text.DateFormatSymbols, java.util.Date, java.time.Month, java.util.Calendar, java.text.SimpleDateFormat" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

</head>
<body>
    <%
        String topic_code = "";
        try 
        {
            Class.forName("com.mysql.jdbc.Driver");   //to load driver class
            Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306", "root", "");
                                            //to build connection between Java and database 
            Statement stmt=con.createStatement();  //create statement class object
            stmt.executeUpdate("Create database if not exists Modern_Gyan_Db");   
                    //"if not exists" used because of database not created multiple times(error)
                        
            stmt.execute("Use Modern_Gyan_Db");

            ResultSet rs = stmt.executeQuery("SELECT topic_code FROM TopicTb where topic_id < 5 ORDER BY student_enrolled desc LIMIT 5");
            while(rs.next())
            {
                topic_code=rs.getString(1);
                out.print(topic_code+"<br>");
            }
                
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
    %>

</body>