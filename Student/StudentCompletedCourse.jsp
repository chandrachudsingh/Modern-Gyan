<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Faculty Completed Courses | Modern-Gyan</title>
    <link rel="stylesheet" href="StudentCompletedCourse.css">
    <link href="https://fonts.googleapis.com/css2?family=Merienda&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Monoton&display=swap" rel="stylesheet">
    <script src="https://kit.fontawesome.com/c99db268c1.js" crossorigin="anonymous"></script>

</head>

<body>

    <%
        int c=0;
        String student_id = (String) application.getAttribute("session_student");

        // today's date
        long millis = System.currentTimeMillis();
        Date today_date = new Date(millis);

        // Counting in progress courses
        try 
        {
            Class.forName("com.mysql.jdbc.Driver");   //to load driver class
            Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306", "root", "");
                                            //to build connection between Java and database 
            Statement stmt=con.createStatement();  //create statement class object
            stmt.executeUpdate("Create database if not exists Modern_Gyan_Db");   
                    //"if not exists" used because of database not created multiple times(error)
                
            stmt.execute("Use Modern_Gyan_Db");

            PreparedStatement pstmt = con.prepareStatement("SELECT count(*) from "+ student_id +"_courses_Tb where start_date <= ? and end_date <= ?");
            pstmt.setDate(1, today_date);
            pstmt.setDate(2, today_date);

            ResultSet rs = pstmt.executeQuery();
            while(rs.next())
                c = rs.getInt(1);

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

        int i=0;
        String[] course_code = new String[c];
        String[] course_type = new String[c];
        int[] slotno = new int[c];

        String[] faculty_code = new String[c];
        String[] platform = new String[c];
        String[] timeslot = new String[c];
        String[] course_name = new String[c];
        String[] meeting_id = new String[c];
        String[] meeting_password = new String[c];
        int[] duration_hrs = new int[c];
        int[] student_enrolled = new int[c];
        Date[] start_date = new Date[c];
        Date[] end_date = new Date[c];

        if(c == 0)
            out.print("<div id='EmptyMessage'><label> All your course classes which are in progress will appear here. </label></div>");
        else
        {
            // getting the courses information
            try
            {
                Class.forName("com.mysql.jdbc.Driver");   //to load driver class
                Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306", "root", "");
                                                //to build connection between Java and database 
                Statement stmt=con.createStatement();  //create statement class object
                stmt.executeUpdate("Create database if not exists Modern_Gyan_Db");   
                        //"if not exists" used because of database not created multiple times(error)
                    
                stmt.execute("Use Modern_Gyan_Db");

                PreparedStatement pstmt = con.prepareStatement("SELECT course_code, course_type, faculty_code, platform, slot, duration, start_date,"
                    + " end_date from " + student_id +"_courses_Tb where start_date <= ? and end_date <= ?");
                pstmt.setDate(1, today_date);
                pstmt.setDate(2, today_date);

                ResultSet rs = pstmt.executeQuery();
                while(rs.next())
                {
                    course_code[i] = rs.getString(1);
                    course_type[i] = rs.getString(2);
                    faculty_code[i] = rs.getString(3);
                    platform[i] = rs.getString(4);
                    timeslot[i] = rs.getString(5);
                    duration_hrs[i] = rs.getInt(6);
                    start_date[i] = rs.getDate(7);
                    end_date[i] = rs.getDate(8);
                    i++;
                }

                // Obtaining Course name, student enrolled, meeting id and meeting password
                for(i=0; i<c; i++)
                {
                    if(course_type.equals("Topic"))
                    {
                        pstmt = con.prepareStatement("SELECT topic_name from TopicTb where topic_code=?");
                        pstmt.setString(1, course_code[i]);
                        rs = pstmt.executeQuery();
                        while(rs.next())
                            course_name[i] = rs.getString(1);
                    }
                    else 
                    {
                        pstmt = con.prepareStatement("SELECT subject_name from SubjectTb where subject_code=?");
                        pstmt.setString(1, course_code[i]);
                        rs = pstmt.executeQuery();
                        while(rs.next())
                            course_name[i] = rs.getString(1);
                    }

                    rs = stmt.executeQuery("SELECT slot1, slot2, slot3, slot4, slot5, slot6 from " + faculty_code[i] +"_timing_Tb");
                    while(rs.next())
                    {
                        for(int j=1; j<=6; j++)
                        {
                            if((rs.getString(j)).equals(timeslot[i]))
                            {
                                slotno[i] = j;
                                break;
                            }
                        }
                    }

                    pstmt = con.prepareStatement("SELECT meeting_id, meeting_password, student_enrolled from " + faculty_code[i] +"_assignsubject_Tb where"
                        + " subject_code=? and slotno=? and assign_date=?");
                    pstmt.setString(1, course_code[i]);
                    pstmt.setInt(2, slotno[i]);
                    pstmt.setDate(3, start_date[i]);

                    rs = pstmt.executeQuery();
                    while(rs.next())
                    {
                        meeting_id[i] = rs.getString(1);
                        meeting_password[i] = rs.getString(2);
                        student_enrolled[i] = rs.getInt(3);
                        i++;
                    }
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
        }
    %>

    <%-- Displaying course data --%>
    <%
        for(i=0; i<c; i++)
        {
            %>
            <div class="CompletedCourses">
                <div class="Details1">
                    <div>
                        <label for="StudentEnrolled<%=i%>" class="lbcontent"> Students </label><label class=" colon">:</label>
                        <input type="text" name="txStudentEnrolled<%=i%>" id="StudentEnrolled<%=i%>" class="StudentEnrolled Smallsize" value="<%= student_enrolled[i] %>" readonly/>
                    </div>
                    <div>
                        <label for="DurationHrs<%=i%>" class="lbcontent"> Duration </label><label class=" colon">:</label>
                        <input type="text" name="txDurationHrs<%=i%>" id="DurationHrs<%=i%>" class="DurationHrs Smallsize" value="<%= duration_hrs[i] %> hrs" readonly/>
                    </div>
                    <div>
                        <label for="StartDate<%=i%>" class="lbcontent"> start Date </label><label class="colon">:</label>
                        <input type="date" name="txStartDate<%=i%>" id="StartDate<%=i%>" class="StartDate Smallsize" value="<%= start_date[i] %>" readonly/>
                    </div>
                    <div>
                        <label for="EndDate<%=i%>" class="lbcontent"> end Date </label><label class="colon">:</label>
                        <input type="date" name="txEndDate<%=i%>" id="EndDate<%=i%>" class="EndDate Smallsize" value="<%= end_date[i] %>" readonly/>
                    </div>
                </div>
                <span class="Details0">
                    <span> 
                        <input type="text" name="txCourseName<%=i%>" class="CourseName Largesize" value="<%= course_name[i] %>" readonly/>
                    </span>
                    <span> 
                        <input type="text" name="txFacultyCode<%=i%>" class="FacultyCode Mediumsize" value="(Faculty code : <%= faculty_code[i] %>)" readonly/>
                    </span>
                </span>
                <div class="Details2">
                    <div>
                        <label for="Platform<%=i%>" class="lbcontent"> Platform : </label>
                        <input type="text" name="txPlatform<%=i%>" id="Platform<%=i%>" class="Platform Smallsize" value="<%= platform[i] %>" readonly/>
                    </div>
                    <div>
                        <label for="TimeSlots<%=i%>" class="lbcontent"> Time slot </label><label class=" colon">:</label>
                        <input type="text" name="txTimeSlot<%=i%>" id="TimeSlots<%=i%>" class="TimeSlot Smallsize" value="<%= timeslot[i] %>" readonly/>
                    </div>
                    <div>
                        <label for="MeetId<%=i%>" class="lbcontent"> Meeting Id : </label> 
                        <input type="text" name="txMeetId<%=i%>" id="MeetId<%=i%>" class="MeetingId Smallsize" value="<%= meeting_id[i] %>" readonly/>
                    </div>
                    <div>
                        <label for="MeetPass<%=i%>" class="lbcontent"> Meeting Password : </label> 
                        <input type="text" name="txMeetPass<%=i%>" id="MeetPass<%=i%>" class="MeetingPassword Smallsize" value="<%= meeting_password[i] %>" readonly/>
                    </div>
                </div>
            </div>
            <%
        }
    %>

</body>
</html>