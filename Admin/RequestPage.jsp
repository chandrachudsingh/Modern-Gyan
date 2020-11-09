<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*, java.util.Date, java.util.Calendar, java.text.SimpleDateFormat, java.text.DateFormatSymbols"
 errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title> Request Page | Modern-Gyan </title>
    <link rel="stylesheet" href="RequestPage.css">
    <link href="https://fonts.googleapis.com/css2?family=Merienda&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Monoton&display=swap" rel="stylesheet">
    <script src="https://kit.fontawesome.com/c99db268c1.js" crossorigin="anonymous"></script>

    <script>
        function Accept() 
        {
            document.getElementById("BtnType").value = "Accept";
        }

        function Reject() 
        {
            document.getElementById("BtnType").value = "Reject";
        }
    </script>
</head>
<body>

    <span id="SiteName" title="Modern-Gyan"> Modern-Gyan </span>
    <span id="PanelName" title="Request Panel"> Request Panel </span>
    
    <%
        Date date = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("MMMM_YYYY");
        String strDate = sdf.format(date);

        SimpleDateFormat sdfMonth = new SimpleDateFormat("MM");
        int intMonth = Integer.parseInt(sdfMonth.format(date));
        String monthString = new DateFormatSymbols().getMonths()[intMonth-2];   //to get previous month
        SimpleDateFormat sdfYear = new SimpleDateFormat("YYYY");
        String preDate = monthString +"_"+ sdfYear.format(date);

        int c=0;
        /* Checking for requests in waiting */
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
					+ " faculty_code varchar(255), course_code varchar(20), slotno varchar(255), platform varchar(255), start_date varchar(255),"
                    + " status varchar(255) default waiting)");

            ResultSet rs = stmt.executeQuery("SELECT count(*) from "+ preDate +"_RequestTb where status='waiting'");
            while(rs.next())
                c = rs.getInt(1);

            rs = stmt.executeQuery("SELECT count(*) from "+ strDate +"_RequestTb where status='waiting'");
            while(rs.next())
                c += rs.getInt(1);

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
        int[] index = new int[c];
        String[] student_id = new String[c];
        String[] faculty_code = new String[c];
        String[] course_code = new String[c];
        int[] slotno = new int[c];
        String[] platform = new String[c];
        java.sql.Date[] start_date = new java.sql.Date[c];
    %>

    <%-- Display all student enrollment requests --%>

    <form action="RequestPageBack.jsp" method="POST">
        <%
            try 
            {
                Class.forName("com.mysql.jdbc.Driver");   //to load driver class
                Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306", "root", "");
                                                //to build connection between Java and database 
                Statement stmt=con.createStatement();  //create statement class object
                stmt.executeUpdate("Create database if not exists Modern_Gyan_Db");   
                        //"if not exists" used because of database not created multiple times(error)
                    
                stmt.execute("Use Modern_Gyan_Db");

                ResultSet rs = stmt.executeQuery("SELECT student_id, faculty_code, course_code, slotno, platform, start_date from "+ preDate +"_RequestTb where status='waiting'");
                while(rs.next())
                {
                    student_id[i] = rs.getString("student_id");
                    faculty_code[i] = rs.getString("faculty_code");
                    course_code[i] = rs.getString("course_code");
                    slotno[i] = rs.getInt("slotno");
                    platform[i] = rs.getString("platform");
                    start_date[i] = rs.getDate("start_date");
                    i++;
                }

                rs = stmt.executeQuery("SELECT student_id, faculty_code, course_code, slotno, platform, start_date from "+ strDate +"_RequestTb where status='waiting'");
                while(rs.next())
                {
                    student_id[i] = rs.getString("student_id");
                    faculty_code[i] = rs.getString("faculty_code");
                    course_code[i] = rs.getString("course_code");
                    slotno[i] = rs.getInt("slotno");
                    platform[i] = rs.getString("platform");
                    start_date[i] = rs.getDate("start_date");
                    i++;
                }

                int[] count_platform = new int[c];
                String[][] faculty_platform = new String[i][];
                for(i=0; i<c; i++)
                {
                    rs = stmt.executeQuery("SELECT count(*) from "+ faculty_code[i] +"_Platform_Tb");
                    while(rs.next())
                        count_platform[i] = rs.getInt(1);

                    faculty_platform[i] = new String[count_platform[i]];
                }

                for(i=0; i<c; i++)
                {
                    int j=0;
                    rs = stmt.executeQuery("SELECT platform from "+ faculty_code[i] +"_Platform_Tb");
                    while(rs.next())
                    {
                        faculty_platform[i][j] = rs.getString(1);
                        if(faculty_platform[i][j].equals(platform[i]))
                            index[i] = j;
                        j++;
                    }
                }
                
                out.print("<div id='RequestPanel'> <div id='RequestPanelHead'> <label class='SerialNo underline'> S. No. </label> <label class='RequestsHead'> Student Id"
                    + " </label> <label class='RequestsHead'> Faculty code </label> <label class='RequestsHead'> Course code </label> <label class='RequestsHead'> Slot No."
                    + " </label> <label class='RequestsHead'> Platform </label> <label class='RequestsHead'> Start Date </label> <label class='RequestsHead'> Operation </label> </div>");
                for(i=0; i<c; i++)
                {
                    out.print("<div class='Requests'> <label class='SerialNo'> "+ (i+1) +". </label> <input type='text' name='txStudentId"+ i +"' value='"+ student_id[i] +"'"
                        + " readonly/> <input type='text' name='txFacultyCode"+ i +"' value='"+ faculty_code[i] +"' readonly/> <input type='text' name='txCourseCode"+ i +"'"
                        + " value='"+ course_code[i] +"' readonly/> <input type='number' name='txSlotNo"+ i +"' value='"+ slotno[i] +"' readonly/>"
                        + " <select name='cbPlatform"+ i +"'>");

                    for(int j=0; j < count_platform[i]; j++)
                        out.print("<option value='"+ faculty_platform[i][j] +"'> "+ faculty_platform[i][j] +"</option>");

                    out.print("</select> <input type='text' name='txStartDate"+ i +"' value='"+ start_date[i] +"' readonly/> <div class='OperationBtn'> <button type='submit'"
                        + " name='sbAccept"+ i +"' onclick='Accept()'> Accept <i class='far fa-check-circle' style='font-size: 18px; color: rgb(0, 255, 21);'></i> </button>"
                        + " <button type='submit' name='sbReject"+ i +"' onclick='Reject'> Reject <i class='far fa-times-circle' style='font-size: 18px; color: red;'></i>"
                        + " </button> </div> </div>");
                }

                out.print("<input type='hidden' id='BtnType' name='hdBtnType'/>");

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
    
    <%-- To by default select the student preferred option --%>
    <%
        for(i=0; i<c; i++)
        {
            %> <script> document.getElementsByName("cbPlatform<%= i %>").item(0).selectedIndex = "<%= index[i] %>"; </script> <%
        }
    %>
    
</body>
</html>