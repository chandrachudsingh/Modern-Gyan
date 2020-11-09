<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Update Faculty Preferences | Modern-Gyan</title>
</head>

<body>

    <%
        String[] subject_name = request.getParameterValues("cbSubName");;
        String[] timeslotfrom = request.getParameterValues("timeSlotfrom");
        String[] timeslotto = request.getParameterValues("timeSlotto");
        String[] platform = request.getParameterValues("cbPlatforms");
   
        int l = subject_name.length;
        String[] subject_code = new String[l];
            
        try 
		{
			Class.forName("com.mysql.jdbc.Driver");   //to load driver class
			Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306", "root", "");
											//to build connection between Java and database 
			Statement stmt=con.createStatement();  //create statement class object
			stmt.executeUpdate("Create database if not exists Modern_Gyan_Db");   
					//"if not exists" used because of database not created multiple times(error)
			
			stmt.execute("Use Modern_Gyan_Db");

            // Update subject codes
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            for(int i=0; i<subject_code.length; i++)
            {
                if(subject_name[i] != null)
                {
                    pstmt = con.prepareStatement("SELECT subject_code from SubjectTb where subject_name = ?");
                    pstmt.setString(1, subject_name[i]);
                    rs = pstmt.executeQuery();
                    while(rs.next())
                        subject_code[i]=rs.getString("subject_code");
                }
            }

            String tb = (String) application.getAttribute("session_faculty") + "_subjectcode_tb";
            stmt.executeUpdate("TRUNCATE table "+ tb);

            for(int i=0; i<subject_code.length; i++)
            {
                if(subject_code[i] != null)
                {
                    pstmt=con.prepareStatement("INSERT INTO "+tb+"(subject_code) VALUES (?)");
                    pstmt.setString(1, subject_code[i]);
                    pstmt.executeUpdate();
                }
            }

            // Update time slots
            l=0;
            String query = "", fields = "";
            for(int i=timeslotfrom.length-1; i>=0; i--)
            {
                if(!timeslotfrom[i].equals(""))
                {
                    l=i+1;
                    break;
                }
            }

            for(int i=0; i<l; i++)
            {
                if(!timeslotfrom[i].equals(""))
                {
                    if(i<l-1)
                    {
                        query += "slot"+ (i+1) +", ";
                        fields += "?,";
                    }
                    else
                    {
                        query += "slot"+ (i+1);
                        fields += "?";
                    }
                }
            }   
                    
            tb = (String) application.getAttribute("session_faculty") + "_timing_tb";
            stmt.executeUpdate("TRUNCATE table "+ tb);

            pstmt=con.prepareStatement("INSERT INTO "+tb+"("+ query +") VALUES ("+ fields +")");

            for(int i=0; i<l; i++)
            {
                if(!timeslotfrom[i].equals(""))
                    pstmt.setString(i+1, timeslotfrom[i] + " - " + timeslotto[i]);
            }
            pstmt.executeUpdate();

            // Update Platforms
			tb = (String) application.getAttribute("session_faculty") + "_platform_tb";
            stmt.executeUpdate("TRUNCATE table "+ tb);

			for(int i=0; i<platform.length; i++)
            {
                pstmt=con.prepareStatement("INSERT INTO "+tb+" (platform) VALUES (?)");
                pstmt.setString(1, platform[i]);
                pstmt.executeUpdate();
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
		
        application.setAttribute("updatestatus", "success");
        response.sendRedirect("FacultyHome.jsp");
    %>

</body>
</html>