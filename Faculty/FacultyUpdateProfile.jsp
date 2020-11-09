<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title> Update Faculty Profile | Modern-Gyan </title>

</head>
<body>
    <%    
        String faculty_code = (String) application.getAttribute("session_faculty");
        String qualification = request.getParameter("tQual");
        String experience = request.getParameter("tExp");
        String address = request.getParameter("tAddress");
        String mobile = request.getParameter("txMobile");
        String email = request.getParameter("txEmail");
        String profession = request.getParameter("tProf");
        String faculty_img = "../Images/"+ request.getParameter("fileFacultyImg");

        try 
        {
            Class.forName("com.mysql.jdbc.Driver");   //to load driver class
            Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306", "root", "");
                                            //to build connection between Java and database 
            Statement stmt=con.createStatement();  //create statement class object
            stmt.executeUpdate("Create database if not exists Modern_Gyan_Db");   
                    //"if not exists" used because of database not created multiple times(error)
                
            stmt.execute("Use Modern_Gyan_Db");

            PreparedStatement pstmt = con.prepareStatement("UPDATE FacultyTb set qualification=?, experience=?, address=?, mobile=?, email=?, curr_Profession=?,"
                + " faculty_img=? where faculty_code=?");
            pstmt.setString(1, qualification);
            pstmt.setString(2, experience);
            pstmt.setString(3, address);
            pstmt.setString(4, mobile);
            pstmt.setString(5, email);
            pstmt.setString(6, profession);
            pstmt.setString(7, faculty_img);
            pstmt.setString(8, faculty_code);
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
    %>

    <script> location.assign("FacultyProfile.jsp"); </script>

</body>
</html>