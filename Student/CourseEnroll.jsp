<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*, java.text.DateFormatSymbols, java.util.Date, java.time.Month, java.util.Calendar, java.text.SimpleDateFormat" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Enrollment Page | Modern-Gyan </title>
    <link rel="stylesheet" href="CourseEnroll.css">
    <link href="https://fonts.googleapis.com/css2?family=Merienda&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Monoton&display=swap" rel="stylesheet">
    <script src="https://kit.fontawesome.com/c99db268c1.js" crossorigin="anonymous"></script>

</head>

<body>

    <%-- website name --%>
    <span id="SiteName" title="Modern-Gyan"> Modern-Gyan </span>

    <%
        int index = 0;
        for(int i=0; ; i++)
        {
            if(request.getParameter("sbCourseDetails"+i) != null)
            {
                index = i;
                break;
            }
        }

        String course_name = request.getParameter("txCourseName"+index);
        String course_code = request.getParameter("txCourseCode"+index);
        String course_fees = request.getParameter("txCourseFees"+index);
        String course_category = request.getParameter("txCategory"+index);
        String subject_code = "", subject_name = "", branch_name = "";
        int duration_hrs = 0;

        application.setAttribute("course_code", course_code);
        application.setAttribute("course_category", course_category);

        // to get odd friday dates
        Calendar today = Calendar.getInstance();
        int dayOfWeek = today.get(Calendar.DAY_OF_WEEK);
        int daysUntilNextFriday = Calendar.FRIDAY - dayOfWeek;

        if(daysUntilNextFriday < 0)
        {
            daysUntilNextFriday = daysUntilNextFriday + 7;
            if(today.get(Calendar.WEEK_OF_MONTH) % 2 != 0)
                daysUntilNextFriday = daysUntilNextFriday + 7;
        }
        else
        {
            if(today.get(Calendar.WEEK_OF_MONTH) % 2 == 0)
                daysUntilNextFriday = daysUntilNextFriday + 7;
        }

        Calendar nextFriday = (Calendar)today.clone();
        nextFriday.add(Calendar.DAY_OF_WEEK, daysUntilNextFriday);
        String start_date = new SimpleDateFormat("YYYY-MM-dd").format(nextFriday.getTime());
        
        try 
        {
            Class.forName("com.mysql.jdbc.Driver");   //to load driver class
            Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306", "root", "");
                                            //to build connection between Java and database 
            Statement stmt=con.createStatement();  //create statement class object
            stmt.executeUpdate("Create database if not exists Modern_Gyan_Db");   
                    //"if not exists" used because of database not created multiple times(error)
                    
            stmt.execute("Use Modern_Gyan_Db");

            String topic_code="", query="";
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            if(course_category.equals("Topic"))
            {
                pstmt = con.prepareStatement("SELECT subject_code, duration_hrs from TopicTb where topic_code = ?");
                pstmt.setString(1, course_code);
                rs = pstmt.executeQuery();
                while(rs.next())
                {
                    subject_code=rs.getString(1);
                    duration_hrs=rs.getInt(2);
                }

                pstmt = con.prepareStatement("SELECT subject_name from SubjectTb where subject_code = ?");
                pstmt.setString(1, subject_code);
                rs = pstmt.executeQuery();
                while(rs.next())
                    subject_name=rs.getString(1);
            }

            if(course_category.equals("Subject"))
                query = ", duration_hrs";
            pstmt = con.prepareStatement("SELECT branch_code "+ query +" from SubjectTb where subject_code = ?");
            if(course_category.equals("Topic"))
                pstmt.setString(1, subject_code);
            else
                pstmt.setString(1, course_code);

            String branch_code = "";
            rs = pstmt.executeQuery();
            while(rs.next())
            {
                branch_code = rs.getString(1);
                if(course_category.equals("Subject"))
                    duration_hrs = rs.getInt(2);
            }

            pstmt = con.prepareStatement("SELECT branch_name from BranchTb where branch_code = ?");
            pstmt.setString(1, branch_code);
            rs = pstmt.executeQuery();
            while(rs.next())
                branch_name = rs.getString(1);

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
    %>

    <%-- Course Details --%>
    <div id="AboutCourse">
        <div id="AboutCourse1">
            <label id="CourseName"> <%= course_name %> </label>
            <%
                if(course_category.equals("Topic"))
                {
                    %> <label id="SubjectName"> # <%= subject_name %> </label> <%
                }
            %>
            <label id="CourseBranch"> # <%= branch_name %> </label>
        </div>
        <div id="AboutCourse2">
            <label id="CourseFees"> <b>Fees : </b> <%= course_fees +" /-" %> </label>
            <label id="CourseDuration"> <b>Duration : </b> <%= duration_hrs +" hrs" %> </label>
            <label id="CourseStart"> <b>Start Date : </b> <%= start_date %> </label>
        </div>
    </div>

    <%-- Note --%>
    <div id="MessagePanel"> <label id="Message">  </label> </div>

    
    <%-- Faculty display panel name & panel --%>
    <span id="PanelName" title="Related faculty"> Related faculty </span>
    <div id="FacultyDisplay">
        <form action="EnrollRequest.jsp" method="POST">
        <%
            int c=0;
            out.print("<input type='hidden' name='hdStartDate' id='CourseStartDate' value='"+ start_date +"' readonly/>");

            out.print("<div id='FacultySlotsHead'> <label class='SerialNo underline'> S. No. </label> <label class='SlotsHeading'>"
                + " Faculty Code </label> <label class='SlotsHeading'> Rating </label> <label class='SlotsHeading'> Time Slots </label>"
                + " <label class='SlotsHeading'> Platforms </label> <label class='SlotsHeading'> Enroll Course </label> </div>");    
    
            try 
            {
                Class.forName("com.mysql.jdbc.Driver");   //to load driver class
                Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306", "root", "");
                                                //to build connection between Java and database 
                Statement stmt=con.createStatement();  //create statement class object
                stmt.executeUpdate("Create database if not exists Modern_Gyan_Db");   
                        //"if not exists" used because of database not created multiple times(error)
                                        
                stmt.execute("Use Modern_Gyan_Db");

                ResultSet rs=stmt.executeQuery("SELECT COUNT(*) from FacultyTb");
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

            String[] faculty_code = new String[c];
            try 
            {
                Class.forName("com.mysql.jdbc.Driver");   //to load driver class
                Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306", "root", "");
                                                //to build connection between Java and database 
                Statement stmt=con.createStatement();  //create statement class object
                stmt.executeUpdate("Create database if not exists Modern_Gyan_Db");   
                        //"if not exists" used because of database not created multiple times(error)
                                        
                stmt.execute("Use Modern_Gyan_Db");

                ResultSet rs=stmt.executeQuery("SELECT faculty_code from FacultyTb");
                int i=0;
                while(rs.next())
                {
                    faculty_code[i] =rs.getString(1);
                    i++;
                }

                /* faculty ratings */
                c=0;
                String options = "", stars = "", platforms = "";
                int j=0, intRating=0, rating_count = 0;
                double rating = 0, decRating = 0;
                String slot1 = "", slot2 = "", slot3 = "", slot4 = "", slot5 = "", slot6 = "";
                PreparedStatement pstmt = null;
                for(i=0; i<faculty_code.length; i++)
                {
                    pstmt = con.prepareStatement("SELECT COUNT(*), rating, rating_count from "+ faculty_code[i] + "_subjectcode_tb where subject_code = ?");
                    if(subject_code == "")
                        pstmt.setString(1, course_code);
                    else
                        pstmt.setString(1, subject_code);
                    rs = pstmt.executeQuery();
                    while(rs.next())
                    {
                        c = rs.getInt(1);
                        rating = rs.getDouble(2);
                        rating_count = rs.getInt(3);
                    }
                    
                    intRating = (int) rating;
                    decRating = Math.round((rating - intRating)*10.0)/10.0;
                    stars = "";
                    for(int k=1; k<=5; k++)
                    {
                        if(k <= intRating)
                            stars += "<i class='fas fa-star' style='color: orange;'></i> ";
                        else
                        {
                            if(intRating == k-1)
                            {
                                if(decRating < .3)
                                    stars += "<i class='far fa-star' style='color: orange;'></i> ";
                                else if(decRating <= .7)
                                    stars += "<i class='fas fa-star-half-alt' style='color: orange;'></i> ";
                                else
                                    stars += "<i class='fas fa-star' style='color: orange;'></i> ";
                            }
                            else
                                stars += "<i class='far fa-star' style='color: orange;'></i> ";
                        }
                    }
                    
                    /* Faculty time slots */
                    if(c == 1)
                    {
                        options = "";
                        int flag = 0;
                        ResultSet rs1 = null;
                        Statement stmt1 = con.createStatement();
                        rs = stmt.executeQuery("SELECT slot1, slot2, slot3, slot4, slot5, slot6 from "+ faculty_code[i] + "_timing_tb");
                        while(rs.next())
                        {   
                            for(int k=1; k<=6; k++)
                            {
                                if(rs.getString(k) != null)
                                {
                                    flag = 0;
                                    rs1 = stmt1.executeQuery("SELECT slotno from "+ faculty_code[i] + "_assignsubject_tb");
                                    while(rs1.next())
                                    {
                                        if(k == rs1.getInt(1))
                                            flag = 1;
                                    }

                                    if(flag == 0)
                                        options += "<option value='"+ k +"'>"+ rs.getString(k) +" </option>" ;
                                }    
                            }
                        }

                        /* Faculty preferred platforms */
                        platforms = "";
                        rs = stmt.executeQuery("SELECT distinct platform from "+ faculty_code[i] + "_platform_tb");
                        while(rs.next())
                        {   
                            platforms += "<option value='"+ rs.getString(1) +"'>"+ rs.getString(1) +" </option>" ;
                        }

                        out.print("<div class='FacultySlots'> <label class='SerialNo'>"+ (j+1) +".</label> <input type='text' name='txFacultyCode"+j+"'"
                            + " value='"+ faculty_code[i] + "' readonly/> <div class='Ratings'> "+ rating +" "+ stars +" ("+ rating_count +" ratings) </div>"
                            + " <select name='cbSlots"+ j +"'>"+ options +" </select> <select name='cbPlatforms"+ j +"'> "+ platforms +" </select>"
                            + " <div class='EnrollBtn'> <input type='submit' name='sbEnroll"+j+"' value='Enroll' ");
                        
                        if((String) application.getAttribute("session_student") == null)
                            out.print("disabled='disabled' style='cursor: not-allowed'");

                        out.print("/></div> </div>");
                        
                        j++;
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
        %>
        </form>
    </div>

    <%-- Note content --%>
    <%
        if((String) application.getAttribute("session_student") == null)
            %><script> document.getElementById("Message").innerHTML = "<ins> Note </ins> : Login to enroll in any course."; </script><%
        else
        {
            %><script> document.getElementById("Message").innerHTML = "<ins> Note </ins> : Enrollment will be successful when the admin approves your request."
                + " If approved, the course will be shown in your upcoming courses list."; </script><%
        }
    %>
</body>
</html>