<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*, java.util.Date, java.text.SimpleDateFormat" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Enroll Request</title>
    <link rel="stylesheet" href="EnrollRequest.css">
</head>

<body>
    <%
        int index = 0;
        for(int i=0; ; i++)
        {
            if(request.getParameter("sbEnroll"+i) != null)
            {
                index = i;
                break;
            }
        }

        String student_id = (String) application.getAttribute("session_student");
        String course_code = (String) application.getAttribute("course_code");
        String course_category = (String) application.getAttribute("course_category");
        String faculty_code = request.getParameter("txFacultyCode"+index);
        int slotno = Integer.parseInt(request.getParameter("cbSlots"+index));
        String platform = request.getParameter("cbPlatforms"+index);
        String start_date = request.getParameter("hdStartDate");

        Date date = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("MMMM_YYYY");
        String strDate = sdf.format(date);

        try 
        {
            Class.forName("com.mysql.jdbc.Driver");   //to load driver class
            Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306", "root", "");
                                            //to build connection between Java and database 
            Statement stmt=con.createStatement();  //create statement class object
            stmt.executeUpdate("Create database if not exists Modern_Gyan_Db");   
                    //"if not exists" used because of database not created multiple times(error)
                                    
            stmt.execute("Use Modern_Gyan_Db");

            stmt.executeUpdate("Create table if not exists "+ strDate +"_RequestTb(request_id int auto_increment primary key, student_id varchar(255)," 
					+ " faculty_code varchar(255), course_code varchar(20), slotno varchar(255), platform varchar(255), start_date date,"
                    + " status varchar(255) default waiting)");

            PreparedStatement pstmt = con.prepareStatement("Insert into "+ strDate +"_RequestTb(student_id, faculty_code, course_code, slotno,"
                + " platform, start_date) values (?,?,?,?,?,?)");
            pstmt.setString(1, student_id);
            pstmt.setString(2, faculty_code);
            pstmt.setString(3, course_code);
            pstmt.setInt(4, slotno);
            pstmt.setString(5, platform);
            pstmt.setString(6, start_date);
            pstmt.executeUpdate();

            con.close();
        }
        catch (ClassNotFoundException e) 
        {
            out.println("ClassNotFoundException caught: "+e.getMessage());
        }
        catch (SQLException e) 
        {
            out.println("ClassNotFoundException caught: "+e.getMessage());
        }
        
        application.removeAttribute("course_code");
        application.removeAttribute("course_category");

        application.setAttribute("status", "success");
		response.sendRedirect("FindCourse.jsp");
    %>
</body>