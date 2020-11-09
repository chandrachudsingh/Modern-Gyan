<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Topic Insert | Modern-Gyan</title>

    <link rel="stylesheet" href="TopicInsert.css">
    <link href="https://fonts.googleapis.com/css2?family=Merienda&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Monoton&display=swap" rel="stylesheet">
    <script src="https://kit.fontawesome.com/c99db268c1.js" crossorigin="anonymous"></script>

    <script>
        function DisableSubmit()
        {
            document.getElementById("btTopicInsert").disabled="disabled";
            document.getElementById("btTopicInsert").style.cursor="not-allowed";

            document.getElementById("topic_code").focus();
        }

        function EnableSubmit()
        {
            if(document.getElementById("topic_code").value!="" && document.getElementById("topic_name").value!="" &&
            document.getElementById("topic_duration").value!="" && document.getElementById("fees").value!="" && 
            document.getElementById("sub_code").selectedIndex!=0)
            {
                document.getElementById("btTopicInsert").disabled="";
                document.getElementById("btTopicInsert").style.cursor="pointer";
            }
        }
    </script>
</head>
<body onload="DisableSubmit()">

    <%-- Site Header --%>
    <jsp:include page="AdminSiteHeader.jsp"/>

    <!-- Topic Insert form -->
    <div id="TopicInsertPanel">
        <h4 id="WorkHead">Insert Topic</h4>
        <form action="TopicInsertBack.jsp">
            <table>
                <tr>
                    <th><label for="topic_code">Topic Code</label></th></th><td class="colon">:</td>
                    <td><input type="text" name="txTopicCode" id="topic_code" onchange="EnableSubmit()"></td>
                </tr>
                <tr>
                    <th><label for="topic_name">Topic Name</label></th></th><td class="colon">:</td>
                    <td><input type="text" name="txTopicName" id="topic_name" onchange="EnableSubmit()"></td>
                </tr>
                <tr>
                    <th><label for="topic_duration">Topic Duration</label></th></th><td class="colon">:</td>
                    <td><input type="number" name="txTopicDuration" id="topic_duration" onchange="EnableSubmit()"></td>
                </tr>
                <tr>
                    <th><label for="fees">Fees</label></th></th><td class="colon">:</td>
                    <td><input type="text" name="txFees" id="fees" onchange="EnableSubmit()"></td>
                </tr>
                <tr>
                    <th><label for="sub_code">Subject Code</label></th></th><td class="colon">:</td>
                    <td>
                        <select name="cbSubCode" id="sub_code" onchange="EnableSubmit()">
                            <option value="-1">Select subject code</option>
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
                                stmt.executeUpdate("Create table if not exists SubjectTb(topic_id int auto_increment primary key,"
                                        + "topic_code varchar(50), topic_name varchar(50), topic_duration int, subject_code varchar(50))");

                                ResultSet rs=stmt.executeQuery("select distinct subject_code from SubjectTb");
                                String opt="";
                                while(rs.next())
                                {
                                    opt=rs.getString("subject_code");
                                    out.print("<option value='"+opt+"'>"+opt+"</option>");
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
                        </select>
                    </td>
                </tr>
            </table>
            <div id="TopicInsertBtn"> <input type="submit" id="btTopicInsert" value="Add Topic"> </div>
        </form>
    </div>
    
    <%-- Success Message --%>
    <div id="SuccessMessage"> <label id="lbMessage">  </label> </div>
    <%
        if((String) application.getAttribute("status") != null)
        {
            %><script> 
                document.getElementById("lbMessage").style.visibility="visible"; 
                document.getElementById("lbMessage").innerHTML = "Admin added successfully <i class='fas fa-check'></i>";
                window.setTimeout('document.getElementById("lbMessage").style.opacity="0"; document.getElementById("lbMessage").style.visibility="hidden";',4000);
            </script><%
        }

        else
        {
            %><script> 
                document.getElementById("lbMessage").style.visibility="hidden"; 
                document.getElementById("lbMessage").innerHTML = "";
            </script><%
        }

        application.removeAttribute("status");
    %>

</body>
</html>