<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*, java.util.Date, java.util.Calendar, java.text.SimpleDateFormat, java.text.DateFormatSymbols" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title> Request Page-Back | Modern-Gyan </title>
    
</head>
<body>
    
    <%
        int index = 0;
        if(request.getParameter("hdBtnType").equals("Accept"))
        {
            for(int i=0; ; i++)
            {
                if(request.getParameter("sbAccept"+i) != null)
                {
                    index = i;
                    break;
                }
            }
        }

        else
        {
            for(int i=0; ; i++)
            {
                if(request.getParameter("sbReject"+i) != null)
                {
                    index = i;
                    break;
                }
            }
        }

        String student_id = request.getParameter("txStudentId"+index);
        String faculty_code = request.getParameter("txFacultyCode"+index);
        String course_code = request.getParameter("txCourseCode"+index);
        int slotno = Integer.parseInt(request.getParameter("txSlotNo"+index));
        String platform = request.getParameter("cbPlatform"+index);

        // start date of the course
        String demodate = request.getParameter("txStartDate"+index);
        java.sql.Date start_date = java.sql.Date.valueOf(demodate);

        String course_type = "", slot = "";
        int student_enrolled = 0;

        Date date = new Date();
        SimpleDateFormat sdf1 = new SimpleDateFormat("MMMM_YYYY");
        String strDate = sdf1.format(date);

        SimpleDateFormat sdfMonth = new SimpleDateFormat("MM");
        int intMonth = Integer.parseInt(sdfMonth.format(date));
        String monthString = new DateFormatSymbols().getMonths()[intMonth-2];   //to get previous month
        SimpleDateFormat sdfYear = new SimpleDateFormat("YYYY");
        String preDate = monthString +"_"+ sdfYear.format(date);

        int c=0;
        if(request.getParameter("hdBtnType").equals("Accept"))
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

                /* Check for course type */
                
                PreparedStatement pstmt = con.prepareStatement("SELECT count(*) from SubjectTb where subject_code=?");
                pstmt.setString(1, course_code);
                ResultSet rs = pstmt.executeQuery();
                while(rs.next())
                    c = rs.getInt(1);

                if(c == 0)
                    course_type = "Topic";
                else
                    course_type = "Subject";

                /* update subjectTb/topicTb */

                if(course_type.equals("Subject"))
                    pstmt = con.prepareStatement("SELECT student_enrolled from SubjectTb where subject_code=?");
                else
                    pstmt = con.prepareStatement("SELECT student_enrolled from TopicTb where topic_code=?");
                pstmt.setString(1, course_code);
                rs = pstmt.executeQuery();
                while(rs.next())
                    c = rs.getInt(1);
                
                if(course_type.equals("Subject"))
                    pstmt = con.prepareStatement("UPDATE SubjectTb set student_enrolled = ? where subject_code = ?");
                else
                    pstmt = con.prepareStatement("UPDATE TopicTb set student_enrolled = ? where topic_code = ?");
                pstmt.setInt(1, c+1);
                pstmt.setString(2, course_code);
                pstmt.executeUpdate();

                /* update facultycode_assignsubject_Tb(faculty assigned course) */

                int platform_id = 0, duration_hrs = 0;
                pstmt = con.prepareStatement("SELECT platform_id from "+ faculty_code +"_platform_Tb where platform=?");
                pstmt.setString(1, platform);
                rs = pstmt.executeQuery();
                while(rs.next())
                    platform_id = rs.getInt(1);

                if(course_type.equals("Subject"))
                    pstmt = con.prepareStatement("SELECT duration_hrs from SubjectTb where subject_code=?");
                else
                    pstmt = con.prepareStatement("SELECT duration_hrs from TopicTb where topic_code=?");
                pstmt.setString(1, course_code);
                rs = pstmt.executeQuery();
                while(rs.next())
                    duration_hrs = rs.getInt(1);

                // end date of the course
                Calendar calendar = Calendar.getInstance();
                calendar.setTime(start_date);
                calendar.add(Calendar.DATE, duration_hrs);
                demodate = new SimpleDateFormat("YYYY-MM-dd").format(calendar.getTime());
                java.sql.Date end_date = java.sql.Date.valueOf(demodate);

                pstmt = con.prepareStatement("SELECT count(*) from "+ faculty_code +"_assignsubject_Tb where slotno=? and subject_code=? and assign_date=?");
                pstmt.setInt(1, slotno);
                pstmt.setString(2, course_code);
                pstmt.setDate(3, start_date);
                rs = pstmt.executeQuery();
                while(rs.next())
                    c = rs.getInt(1);
                
                if(c == 0)
                {
                    pstmt = con.prepareStatement("Insert into "+ faculty_code +"_assignsubject_Tb (platform_id, slotno, subject_code, student_enrolled, assign_date, finish_date)"
                    + "Values(?,?,?,?,?,?)");
                    pstmt.setInt(1, platform_id);
                    pstmt.setInt(2, slotno);
                    pstmt.setString(3, course_code);
                    pstmt.setInt(4, 1);
                    pstmt.setDate(5, start_date);
                    pstmt.setDate(6, end_date);
                    pstmt.executeUpdate();
                }
                else
                {
                    pstmt = con.prepareStatement("SELECT student_enrolled from "+ faculty_code +"_assignsubject_Tb where slotno=? and subject_code=? assign_date=?");
                    pstmt.setInt(1, slotno);
                    pstmt.setString(2, course_code);
                    pstmt.setDate(3, start_date);
                    rs = pstmt.executeQuery();
                    while(rs.next())
                        student_enrolled = rs.getInt(1);

                    pstmt = con.prepareStatement("Update "+ faculty_code +"_assignsubject_Tb set student_enrolled=?");
                    pstmt.setInt(1, student_enrolled+1);
                    pstmt.executeUpdate();
                }

                /* update student_courses_Tb */

                rs = stmt.executeQuery("SELECT slot"+ slotno +" from "+ faculty_code +"_timing_Tb");
                while(rs.next())
                    slot = rs.getString(1);

                pstmt = con.prepareStatement("Insert into "+ student_id +"_courses_Tb (course_code, course_type, faculty_code, platform, slot, duration, start_date,"
                    + " end_date) Values (?,?,?,?,?,?,?,?)");
                pstmt.setString(1, course_code);
                pstmt.setString(2, course_type);
                pstmt.setString(3, faculty_code);
                pstmt.setString(4, platform);
                pstmt.setString(5, slot);
                pstmt.setInt(6, duration_hrs);
                pstmt.setDate(7, start_date);
                pstmt.setDate(8, end_date);
                pstmt.executeUpdate(); 

                /* status update 'Accepted' */

                pstmt = con.prepareStatement("UPDATE "+ strDate +"_RequestTb set status = 'Accepted' where student_id = ? and faculty_code = ? and"
                    + " course_code = ? and slotno = ?");
                pstmt.setString(1, student_id);
                pstmt.setString(2, faculty_code);
                pstmt.setString(3, course_code);
                pstmt.setInt(4, slotno);
                pstmt.executeUpdate();

                pstmt = con.prepareStatement("UPDATE "+ preDate +"_RequestTb set status = 'Accepted' where student_id = ? and faculty_code = ? and"
                    + " course_code = ? and slotno = ?");
                pstmt.setString(1, student_id);
                pstmt.setString(2, faculty_code);
                pstmt.setString(3, course_code);
                pstmt.setInt(4, slotno);
                pstmt.executeUpdate();            

                con.close();
            }
            catch (ClassNotFoundException e) 
            {
                out.println("ClassNotFoundException caught: "+e.getMessage());
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

                /* status update 'Rejected' */
                
                PreparedStatement pstmt = con.prepareStatement("UPDATE "+ strDate +"_RequestTb set status = 'Rejected' where student_id = ? and"
                    + " faculty_code = ? and course_code = ? and slotno = ?");
                pstmt.setString(1, student_id);
                pstmt.setString(2, faculty_code);
                pstmt.setString(3, course_code);
                pstmt.setInt(4, slotno);
                pstmt.executeUpdate(); 

                pstmt = con.prepareStatement("UPDATE "+ preDate +"_RequestTb set status = 'Rejected' where student_id = ? and"
                    + " faculty_code = ? and course_code = ? and slotno = ?");
                pstmt.setString(1, student_id);
                pstmt.setString(2, faculty_code);
                pstmt.setString(3, course_code);
                pstmt.setInt(4, slotno);
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
        }

        response.sendRedirect("RequestPage.jsp");
    %>

</body>
</html>