<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Update Meeting Details | Modern-Gyan</title>

</head>
<body>

    <%-- Updating meeting id and password --%>
    <%
        int index = 0;
        for(int i=0; ; i++)
        {
            if(request.getParameter("sbSend"+i) != null)
            {
                index = i;
                break;
            }
        }

        String faculty_code = (String) application.getAttribute("session_faculty");
        String meeting_id = request.getParameter("txMeetId"+index);
        String meeting_password = request.getParameter("txMeetPass"+index);
        String subject_code = request.getParameter("hdSubCode"+index);
        int slotno = Integer.parseInt(request.getParameter("hdSlotNo"+index));
        String assign_date = request.getParameter("txAssignDate"+index);

        try 
        {
            Class.forName("com.mysql.jdbc.Driver");   //to load driver class
            Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306", "root", "");
                                            //to build connection between Java and database 
            Statement stmt=con.createStatement();  //create statement class object
            stmt.executeUpdate("Create database if not exists Modern_Gyan_Db");   
                    //"if not exists" used because of database not created multiple times(error)
                
            stmt.execute("Use Modern_Gyan_Db");

            PreparedStatement pstmt = con.prepareStatement("Update "+ faculty_code +"_assignsubject_Tb set meeting_id = ?, meeting_password = ? where"
                + " subject_code = ? and slotno = ? and assign_date = ?");
            pstmt.setString(1, meeting_id);
            pstmt.setString(2, meeting_password);
            pstmt.setString(3, subject_code);
            pstmt.setInt(4, slotno);
            pstmt.setString(5, assign_date);
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
    %>

    <script> 
        if(document.referrer == "http://localhost:8080/Modern-Gyan/Faculty/FacultyOngoingCourse.jsp")
            location.assign("FacultyOngoingCourse.jsp"); 
        else
            location.assign("FacultyUpcomingCourse.jsp");
    </script>

</body>