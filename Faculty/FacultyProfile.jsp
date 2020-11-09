<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title> Faculty Profile | Modern-Gyan </title>
    <link rel="stylesheet" href="FacultyProfile.css">
    <link href="https://fonts.googleapis.com/css2?family=Monoton&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Merienda&display=swap" rel="stylesheet">
    <script src="https://kit.fontawesome.com/c99db268c1.js" crossorigin="anonymous"></script>

    <script>
        function FirstAppearance() 
        {
            document.getElementById("qualification").disabled = "disabled";   
            document.getElementById("experience").disabled = "disabled";   
            document.getElementById("address").disabled = "disabled";   
            document.getElementById("mobile").disabled = "disabled";   
            document.getElementById("email").disabled = "disabled";   
            document.getElementById("profession").disabled = "disabled";

            document.getElementById("qualification").style.boxShadow = "none";
            document.getElementById("experience").style.boxShadow = "none";
            document.getElementById("address").style.boxShadow = "none";
            document.getElementById("mobile").style.boxShadow = "none";
            document.getElementById("email").style.boxShadow = "none";
            document.getElementById("profession").style.boxShadow = "none";

            document.getElementById("FacultyImagePanel").style.display = "none";
            document.getElementsByName("sbUpdate").item(0).style.display = "none";
        }

        function UpdatableData() 
        {
            document.getElementById("qualification").disabled = "";   
            document.getElementById("experience").disabled = "";   
            document.getElementById("address").disabled = "";   
            document.getElementById("mobile").disabled = "";   
            document.getElementById("email").disabled = "";   
            document.getElementById("profession").disabled = "";

            document.getElementById("qualification").style.boxShadow = "2px 2px 4px rgb(168, 168, 168)";
            document.getElementById("experience").style.boxShadow = "2px 2px 4px rgb(168, 168, 168)";
            document.getElementById("address").style.boxShadow = "2px 2px 4px rgb(168, 168, 168)";
            document.getElementById("mobile").style.boxShadow = "2px 2px 4px rgb(168, 168, 168)";
            document.getElementById("email").style.boxShadow = "2px 2px 4px rgb(168, 168, 168)";
            document.getElementById("profession").style.boxShadow = "2px 2px 4px rgb(168, 168, 168)";

            document.getElementById("FacultyImagePanel").style.display = "";
            document.getElementsByName("sbUpdate").item(0).style.display = "inline";    
            document.getElementsByName("btChange").item(0).style.display = "none";  

            document.getElementById("qualification").focus(); 
        }

        function ImageChange()
        {
            var path = (document.getElementById("faculty_img").value).replace("C:\\fakepath\\", "");      //replaces the provided string with the required one
            document.getElementById("FacultyImage").src = "../Images/"+ path;
        }

        function ClickInputFile()
        {
            document.getElementById("faculty_img").click();
        }
    </script>
</head>
<body onload="FirstAppearance()">

    <%-- Collecting the data needed --%>
    <%
        String faculty_code = "";
        if((String) application.getAttribute("session_faculty") != null)
            faculty_code = (String) application.getAttribute("session_faculty");
        else
        {   
            int index = 0;
            for(int i=0; ; i++)
            {
                if(request.getParameter("sbDetails"+i) != null)
                {
                    index = i;
                    break;
                }
            }

            faculty_code = request.getParameter("txFacultyCode"+ index);
        }

        String faculty_name = "", gender = "", qualification = "", experience = "", address = "", mobile = "", email = "", curr_profession = "";
        String faculty_img = "", facultycode_img = "";
        java.sql.Date dob = null;

        try 
        {
            Class.forName("com.mysql.jdbc.Driver");   //to load driver class
            Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306", "root", "");
                                            //to build connection between Java and database 
            Statement stmt=con.createStatement();  //create statement class object
            stmt.executeUpdate("Create database if not exists Modern_Gyan_Db");   
                    //"if not exists" used because of database not created multiple times(error)
                
            stmt.execute("Use Modern_Gyan_Db");

            PreparedStatement pstmt = con.prepareStatement("SELECT * from FacultyTb where faculty_code = ?");
            pstmt.setString(1, faculty_code);

            ResultSet rs = pstmt.executeQuery();
            while(rs.next())
            {
                faculty_name = rs.getString("faculty_name");
                dob = rs.getDate("dob");
                gender = rs.getString("gender");
                qualification = rs.getString("qualification");
                experience = rs.getString("experience");
                address = rs.getString("address");
                mobile = rs.getString("mobile");
                email = rs.getString("email");
                curr_profession = rs.getString("curr_Profession");
                faculty_img = rs.getString("faculty_img");
                facultycode_img = rs.getString("facultycode_img");
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

    <%-- Faculty info. display (Non-changeable)  --%>
    <span id="SiteName" title="Modern-Gyan"> Modern-Gyan </span>
    <div id="FacultyIntro">
        <div id="FacultyImg"> <img src="<%= faculty_img %>"> </div>
        <div id="FacultyInfo">
            <span id="FacultyInfo1">
                <img src="<%= facultycode_img %>" alt="" id="FacultyCodeImg">
                <span>
                    <label id="FacultyName"> <%= faculty_name %> </label><br>
                    <label id="FacultyCode"> <%= "( "+ faculty_code +" )" %> </label>
                </span>
            </span>

            <span id="FacultyInfo2">
                <table>
                    <tr>
                        <th> Gender </th>
                        <td> : <%= gender %> </td>
                    </tr>
                    <tr>
                        <th> Date of Birth </th>
                        <td> : <%= dob %> </td>
                    </tr>
                </table>
            </span>
        </div>

        <%-- Faculty's all Assigned Subject Info --%>
        <fieldset id="AssignPanel">
            <legend> Assigned subjects </legend>
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

                    int platform_id = 0, slotno = 0, i = 1;
                    String assigned_subject = "";
                    java.util.Date finish_date = null;

                    out.print("<div class='DisplayAssignsHead'> <label class='SerialNo1'> S.No. </label> <label class='PlatformId'> Platform Id" 
                        + " </label> <label class='SlotNo'> Slot No. </label> <label class='AssignedDate'> Subject </label>"
                        + " <label class='FinishDate'> Finish Date </label> </div>");
                        
                    ResultSet rs = stmt.executeQuery("SELECT platform_id, slotno, subject_code, finish_date from "+ faculty_code +"_assignsubject_Tb");
                    while(rs.next())
                    {
                        platform_id = rs.getInt(1);
                        slotno = rs.getInt(2);
                        assigned_subject = rs.getString(3);
                        finish_date = rs.getDate(4);
                        
                        out.print("<div class='DisplayAssigns'> <label class='SerialNo1'> "+ i +") </label> <label class='PlatformId'>"+ platform_id 
                            + " </label> <label class='SlotNo'>"+ slotno +"</label> <label class='AssignedDate'>"+ assigned_subject +"</label>"
                            + " <label class='FinishDate'>"+ finish_date +"</label> </div>");
                        i++;
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
        </fieldset>
    </div>

    <div id="FacultyData">
        
        <%-- Faculty data (Changeable) --%>
        <fieldset id="PersonalInfo">
            <legend> Personal Information </legend>
            <form action="FacultyUpdateProfile.jsp" method="POST">
                <table>
                    <tr>
                        <th><label for="qualification">Qualification</label></th><td class="colon">:</td>
                        <td><textarea name="tQual" id="qualification" min-length="1"> <%= qualification %> </textarea></td>
                    </tr>
                    <tr>
                        <th><label for="experience">Experience</label></th><td class="colon">:</td>
                        <td><textarea name="tExp" id="experience" min-length="1"> <%= experience %> </textarea></td>
                    </tr>
                    <tr>
                        <th><label for="address">Address</label></th><td class="colon">:</td>
                        <td><textarea name="tAddress" id="address" min-length="1"> <%= address %> </textarea></td>
                    </tr>
                    <tr>
                        <th><label for="mobile">Mobile No</label></th><td class="colon">:</td>
                        <td><input type="tel" name="txMobile" id="mobile" min-length="10" max-length="10" value="<%= mobile %>"></td>
                    </tr>
                    <tr>
                        <th><label for="email">Email</label></th><td class="colon">:</td>
                        <td><input type="email" name="txEmail" id="email" min-length="1" value="<%= email %>"></td>
                    </tr>
                    <tr>
                        <th><label for="profession">Current Profession</label></th><td class="colon">:</td>
                        <td><textarea name="tProf" id="profession" min-length="1"> <%= curr_profession %> </textarea></td>
                    </tr>
                    <tr id="FacultyImagePanel">
                        <th><label for="faculty_img">Faculty Image</label></th><td class="colon">:</td>
                        <td id="FacultyImageChoose">
                            <span><input type="file" name="fileFacultyImg" id="faculty_img" value="" onchange="ImageChange()"> 
                                <label id="lbImg" onclick="ClickInputFile()"> <i class="fa fa-upload"></i> Browse image </label></span>
                            <span><img src="<%= faculty_img %>" id="FacultyImage"/></span>
                        </td>
                    </tr>
                </table>

                <div id="UpdateBtn">
                    <input type="button" name="btChange" value="Change" onclick="UpdatableData()"/>
                    <input type="submit" name="sbUpdate" value="Update"/>
                </div>
            </form>
        </fieldset>

        <%
            if((String) application.getAttribute("session_faculty") == null)
            {
                %> <script> 
                    document.getElementById("UpdateBtn").style.display = "none"; 
                    document.getElementById("FacultyImagePanel").style.display = "none"; 
                </script> <%
            }
        %>

        <%-- Faculty's Preferences --%>
        <div id="Preferences">
            <%
                int count_subjects = 0, count_platforms = 0, count_timing = 0;
                try 
                {
                    Class.forName("com.mysql.jdbc.Driver");   //to load driver class
                    Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306", "root", "");
                                                    //to build connection between Java and database 
                    Statement stmt=con.createStatement();  //create statement class object
                    stmt.executeUpdate("Create database if not exists Modern_Gyan_Db");   
                            //"if not exists" used because of database not created multiple times(error)
                        
                    stmt.execute("Use Modern_Gyan_Db");

                    ResultSet rs = stmt.executeQuery("SELECT count(*) from "+ faculty_code +"_subjectcode_Tb");
                    while(rs.next())
                        count_subjects = rs.getInt(1);

                    rs = stmt.executeQuery("SELECT count(*) from "+ faculty_code +"_platform_Tb");
                    while(rs.next())
                        count_platforms = rs.getInt(1);

                    String slot = "";
                    rs = stmt.executeQuery("SELECT slot1, slot2, slot3, slot4, slot5, slot6 from "+ faculty_code +"_timing_Tb");
                    while(rs.next())
                    {   
                        for(int i=1; i<=6 && rs.getString(i)!=null; i++)
                            count_timing++;
                        break;
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

                try 
                {
                    Class.forName("com.mysql.jdbc.Driver");   //to load driver class
                    Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306", "root", "");
                                                    //to build connection between Java and database 
                    Statement stmt=con.createStatement();  //create statement class object
                    stmt.executeUpdate("Create database if not exists Modern_Gyan_Db");   
                            //"if not exists" used because of database not created multiple times(error)
                        
                    stmt.execute("Use Modern_Gyan_Db");

                    int i = 0;
                    String[] subject_code = new String[count_subjects];
                    String[] subject_name = new String[count_subjects];
                    double[] rating = new double[count_subjects];
                    int[] rating_count = new int[count_subjects];
                    ResultSet rs = stmt.executeQuery("SELECT subject_code, rating, rating_count from "+ faculty_code +"_subjectcode_Tb");
                    while(rs.next())
                    {
                        subject_code[i] = rs.getString(1);
                        rating[i] = rs.getDouble(2);
                        rating_count[i] = rs.getInt(3);
                        i++;
                    }

                    /* Preferred subjects */
                    PreparedStatement pstmt = null;
                    for(i=0; i<count_subjects; i++)
                    {
                        pstmt = con.prepareStatement("SELECT subject_name from SubjectTb where subject_code = ?");
                        pstmt.setString(1, subject_code[i]);
                        rs = pstmt.executeQuery();
                        while(rs.next())
                            subject_name[i] = rs.getString(1);
                    }

                    out.print("<div id='SubjectList'> <div id='SubjectsListHead'> <label id='lbSubjects'> Preferred subjects </label> </div> ");
                    for(i=0; i<count_subjects; i++)
                    {
                        out.print("<div class='Subjects'> <label class='SerialNo2'> "+ (i+1) +"). </label> <label class='SubjectName'>"+ subject_name[i]
                              + " </label> <label class='Rating'>"+ rating[i] +"<i class='fas fa-star' style='color: orange;'></i>"
                              + " ("+ rating_count[i] +" ) </label> </div>");
                    }
                    out.print(" </div>");

                    /* Preferred platform */
                    i=0;
                    int[] platform_id = new int[count_platforms];
                    String[] platform = new String[count_platforms];
                    rs = stmt.executeQuery("SELECT platform_id, platform from "+ faculty_code +"_platform_Tb order by platform_id");
                    while(rs.next())
                    {
                        platform_id[i] = rs.getInt(1);
                        platform[i] = rs.getString(2);
                        i++;
                    }

                    out.print("<div id='PlatformList'> <div id='PlatformsListHead'> <label id='lbPlatforms'> Preferred platforms </label> </div>"
                        + "<div class='PlatformsHead'> <label class='PlatformIdHead'> P. Id </label> <label class='PlatformNameHead'> Platform </label> </div>");
                    for(i=0; i<count_platforms; i++)
                    {
                        out.print("<div class='Platforms'> <label class='PlatformId'>"+ platform_id[i] +". </label> <label class='PlatformName'>"
                              + platform[i] +" </label> </div>");
                    }
                    out.print(" </div>");

                    /* Preferred time slots */
                    String[] slots = new String[count_timing];
                    rs = stmt.executeQuery("SELECT slot1, slot2, slot3, slot4, slot5, slot6 from "+ faculty_code +"_timing_Tb");
                    while(rs.next())
                    {
                        for(i=0; i<count_timing; i++)
                            slots[i] = rs.getString(i+1);
                    }

                    out.print("<div id='SlotsList'> <div id='SlotsListHead'> <label id='lbSlots'> Preferred timing slots </label> </div> <div class='Slots'>");
                    for(i=0; i<count_timing; i++)
                    {
                        out.print("<div class='Slot'> <label class='SerialNo3'> "+ (i+1) +"). </label> <label class='TimingSlots'>"+ slots[i] + " </label> </div> ");
                    }
                    out.print(" </div> </div>");

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
        </div>
    </div>

</body>
</html>