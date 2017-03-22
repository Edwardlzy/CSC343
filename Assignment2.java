import java.sql.*;

// Remember that part of your mark is for doing as much in SQL (not Java)
// as you can. At most you can justify using an array, or the more flexible
// ArrayList. Don't go crazy with it, though. You need it rarely if at all.
import java.util.ArrayList;

public class Assignment2 {
    
    // A connection to the database
    Connection connection;
    
    Assignment2() throws SQLException {
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
    
    /**
     * Connects to the database and sets the search path.
     *
     * Establishes a connection to be used for this session, assigning it to the
     * instance variable 'connection'. In addition, sets the search path to
     * markus.
     *
     * @param url
     *            the url for the database
     * @param username
     *            the username to be used to connect to the database
     * @param password
     *            the password to be used to connect to the database
     * @return true if connecting is successful, false otherwise
     */
    public boolean connectDB(String URL, String username, String password) {
        // Replace this return statement with an implementation of this method!
        
        try{
            this.connection = DriverManager.getConnection(URL, username, password);
            
            Statement stmt = this.connection.createStatement();
            stmt.execute("SET search_path to markus;");
            stmt.close();
            
            return true;
        }
        catch (SQLException se) {
            //            System.err.println("SQL Exception." +
            //                    "<Message>: " + se.getMessage());
            se.printStackTrace();
            return false;
        }
    }
    
    /**
     * Closes the database connection.
     *
     * @return true if the closing was successful, false otherwise
     */
    public boolean disconnectDB() {
        // Replace this return statement with an implementation of this method!
        try{
            this.connection.close();
            return true;
        }
        catch (SQLException se) {
            //            System.err.println("SQL Exception." +
            //                    "<Message>: " + se.getMessage());
            se.printStackTrace();
            return false;
        }
    }
    
    /**
     * Assigns a grader for a group for an assignment.
     *
     * Returns false if the groupID does not exist in the AssignmentGroup table,
     * if some grader has already been assigned to the group, or if grader is
     * not either a TA or instructor.
     *
     * @param groupID
     *            id of the group
     * @param grader
     *            username of the grader
     * @return true if the operation was successful, false otherwise
     */
    public boolean assignGrader(int groupID, String grader) {
        // Replace this return statement with an implementation of this method!
        
        try{
            PreparedStatement pstmt;
            ResultSet rs;
            
            ////////////////////////////////////////////////////////////
            //System.out.println("Current Grader: ");
            //pstmt = this.connection.prepareStatement("select * from Grader;");
            //rs = pstmt.executeQuery();
            //while(rs.next()) {
            //System.out.println(rs.getInt("group_id"));
            //System.out.println(rs.getString("username"));
            //}
            ////////////////////////////////////////////////////////////
            
            String query1 = "SELECT * FROM AssignmentGroup WHERE group_id=?;";
            
            pstmt = this.connection.prepareStatement(query1);
            pstmt.setInt(1, groupID);
            
            rs = pstmt.executeQuery();
            if (!rs.next()){
                //groupID does not exist in AssignmentGroup
                pstmt.close();
                rs.close();
                //System.out.println("groupID does not exist in AssignmentGroup");
                return false;
            }
            
            String query2 = "SELECT * FROM Grader WHERE group_id=?;";
            pstmt = this.connection.prepareStatement(query2);
            pstmt.setInt(1, groupID);
            rs = pstmt.executeQuery();
            if (rs.next()){
                //groupID already has an assigned grader
                pstmt.close();
                rs.close();
                //System.out.println("groupID already has an assigned grader");
                return false;
            }
            
            String query3 = "SELECT * FROM MarkusUser WHERE username=? AND type = 'student';";
            pstmt = this.connection.prepareStatement(query3);
            pstmt.setString(1, grader);
            rs= pstmt.executeQuery();
            if (rs.next()) {
                pstmt.close();
                rs.close();
                //System.out.println("User type is not instructor or ta.");
                return false;
            }
            
            // Insert the tuple into Grader.
            String query4 = "INSERT INTO Grader(group_id, username) VALUES (?,?);";
            pstmt = this.connection.prepareStatement(query4);
            pstmt.setInt(1, groupID);
            pstmt.setString(2, grader);
            
            //System.out.println("Successfully inserted.");
            
            pstmt.executeUpdate();
            
            ////////////////////////////////////////////////////////////
            //System.out.println("After insertion, Grader: ");
            //pstmt = this.connection.prepareStatement("select * from Grader;");
            //rs = pstmt.executeQuery();
            //while(rs.next()) {
            //System.out.println(rs.getInt("group_id"));
            //System.out.println(rs.getString("username"));
            //}
            ////////////////////////////////////////////////////////////
            
            pstmt.close();
            rs.close();
            
            return true;
        }
        catch (SQLException se) {
            //            System.err.println("SQL Exception." +
            //                    "<Message>: " + se.getMessage());
            se.printStackTrace();
            return false;
        }
    }
    
    /**
     * Adds a member to a group for an assignment.
     *
     * Records the fact that a new member is part of a group for an assignment.
     * Does nothing (but returns true) if the member is already declared to be
     * in the group.
     *
     * Does nothing and returns false if any of these conditions hold: - the
     * group is already at capacity, - newMember is not a valid username or is
     * not a student, - there is no assignment with this assignment ID, or - the
     * group ID has not been declared for the assignment.
     *
     * @param assignmentID
     *            id of the assignment
     * @param groupID
     *            id of the group to receive a new member
     * @param newMember
     *            username of the new member to be added to the group
     * @return true if the operation was successful, false otherwise
     */
    public boolean recordMember(int assignmentID, int groupID, String newMember) {
        // Replace this return statement with an implementation of this method!
        
        try{
            PreparedStatement pstmt;
            ResultSet rs;
            
            
            ////////////////////////////////////////////////////////////
            //System.out.println("Current Membership: ");
            //pstmt = this.connection.prepareStatement("select * from Membership;");
            //rs = pstmt.executeQuery();
            //while(rs.next()) {
            //System.out.println(rs.getString("username"));
            //System.out.println(rs.getInt("group_id"));
            //}
            ////////////////////////////////////////////////////////////
            
            // Check if the member is already in the group.
            String query1 = "SELECT * FROM Membership WHERE username=? AND group_id=?;";
            pstmt = this.connection.prepareStatement(query1);
            pstmt.setString(1, newMember);
            pstmt.setInt(2, groupID);
            
            rs = pstmt.executeQuery();
            if(rs.next()){
                pstmt.close();
                rs.close();
                //System.out.println("Already declared membership!");
                return true;
            }
            
            // Check if assignmentID exists in Assignment.
            String query2 = "SELECT * FROM Assignment WHERE assignment_id=?;";
            pstmt = this.connection.prepareStatement(query2);
            pstmt.setInt(1,  assignmentID);
            
            rs = pstmt.executeQuery();
            if (!rs.next()){
                pstmt.close();
                rs.close();
                //System.out.println("assignmentID does not exist in Assignment!");
                return false;
            }
            
            String query3 = "SELECT * FROM AssignmentGroup WHERE group_id=? AND assignment_id=?;";
            pstmt = this.connection.prepareStatement(query3);
            pstmt.setInt(1, groupID);
            pstmt.setInt(2, assignmentID);
            
            rs = pstmt.executeQuery();
            if (!rs.next()){
                //groupID, assignmentID does not exist in AssignmentGroup
                pstmt.close();
                rs.close();
                //System.out.println("groupID, assignmentID does not exist in AssignmentGroup!");
                return false;
            }
            
            String query4 = "SELECT count(*) AS numMembers FROM AssignmentGroup NATURAL JOIN Membership "
            + "WHERE AssignmentGroup.group_id=?;";
            pstmt= this.connection.prepareStatement(query4);
            pstmt.setInt(1, groupID);
            
            rs = pstmt.executeQuery();
            int numMembers = 0;
            if (rs.next())
                numMembers = rs.getInt("numMembers");
            
            //System.out.println("The number of members in the group is " + numMembers);
            
            pstmt = this.connection.prepareStatement("SELECT group_max FROM Assignment WHERE assignment_id=?;");
            pstmt.setInt(1, assignmentID);
            
            rs = pstmt.executeQuery();
            int group_max = 0;
            if (rs.next())
                group_max = rs.getInt("group_max");
            
            //System.out.println("group_max is " + group_max);
            
            if (numMembers >= group_max){
                //group is full
                pstmt.close();
                rs.close();
                //System.out.println("group is full!");
                return false;
            }
            
            pstmt = this.connection.prepareStatement("SELECT * FROM MarkusUser WHERE username=?;");
            pstmt.setString(1, newMember);
            rs = pstmt.executeQuery();
            
            if (!rs.next() || !rs.getString("type").equals("student")){
                //newMember is an invalid username or is not a student
                pstmt.close();
                rs.close();
                //System.out.println("newMember is an invalid username or is not a student");
                return false;
            }
            
            pstmt = this.connection.prepareStatement("INSERT INTO Membership(username, group_id) VALUES (?,?);");
            pstmt.setString(1, newMember);
            pstmt.setInt(2, groupID);
            
            //System.out.println("Updating the Membership...");
            
            pstmt.executeUpdate();
            
            ////////////////////////////////////////////////////////////
            //System.out.println("After insertion, Membership: ");
            //pstmt = this.connection.prepareStatement("select * from Membership;");
            //rs = pstmt.executeQuery();
            //while(rs.next()) {
            //System.out.println(rs.getString("username"));
            //System.out.println(rs.getInt("group_id"));
            //}
            ////////////////////////////////////////////////////////////
            
            pstmt.close();
            rs.close();
            
            return true;
        }
        catch (SQLException se) {
            //            System.err.println("SQL Exception." +
            //                    "<Message>: " + se.getMessage());
            se.printStackTrace();
            return false;
        }
    }
    
    /**
     * Creates student groups for an assignment.
     *
     * Finds all students who are defined in the Users table and puts each of
     * them into a group for the assignment. Suppose there are n. Each group
     * will be of the maximum size allowed for the assignment (call that k),
     * except for possibly one group of smaller size if n is not divisible by k.
     * Note that k may be as low as 1.
     *
     * The choice of which students to put together is based on their grades on
     * another assignment, as recorded in table Results. Starting from the
     * highest grade on that other assignment, the top k students go into one
     * group, then the next k students go into the next, and so on. The last n %
     * k students form a smaller group.
     *
     * In the extreme case that there are no students, does nothing and returns
     * true.
     *
     * Students with no grade recorded for the other assignment come at the
     * bottom of the list, after students who received zero. When there is a tie
     * for grade (or non-grade) on the other assignment, takes students in order
     * by username, using alphabetical order from A to Z.
     *
     * When a group is created, its group ID is generated automatically because
     * the group_id attribute of table AssignmentGroup is of type SERIAL. The
     * value of attribute repo is repoPrefix + "/group_" + group_id
     *
     * Does nothing and returns false if there is no assignment with ID
     * assignmentToGroup or no assignment with ID otherAssignment, or if any
     * group has already been defined for this assignment.
     *
     * @param assignmentToGroup
     *            the assignment ID of the assignment for which groups are to be
     *            created
     * @param otherAssignment
     *            the assignment ID of the other assignment on which the
     *            grouping is to be based
     * @param repoPrefix
     *            the prefix of the URL for the group's repository
     * @return true if successful and false otherwise
     */
    public boolean createGroups(int assignmentToGroup, int otherAssignment,
                                String repoPrefix) {
        // Replace this return statement with an implementation of this method!
        
        try{
            PreparedStatement pstmt;
            ResultSet rs;
            
            ////////////////////////////////////////////////////////////
            //System.out.println("Current Membership: ");
            //pstmt = this.connection.prepareStatement("select * from Membership;");
            //rs = pstmt.executeQuery();
            //while(rs.next()) {
            //System.out.println(rs.getString("username"));
            //System.out.println(rs.getInt("group_id"));
            //}
            ////////////////////////////////////////////////////////////
            
            String query1 = "SELECT * FROM Assignment WHERE assignment_id=?;";
            pstmt = this.connection.prepareStatement(query1);
            pstmt.setInt(1, assignmentToGroup);
            
            rs = pstmt.executeQuery();
            if (!rs.next()){
                //assignmentToGroup does not exist in Assignment
                pstmt.close();
                rs.close();
                //System.out.println("assignmentToGroup does not exist in Assignment");
                return false;
            }
            
            int groupMax = 0;
            groupMax = rs.getInt("group_max");
            
            //System.out.println("groupMax is " + groupMax);
            
            String query2 = "SELECT * FROM Assignment WHERE assignment_id=?;";
            pstmt = this.connection.prepareStatement(query2);
            pstmt.setInt(1, otherAssignment);
            
            rs = pstmt.executeQuery();
            if (!rs.next()){
                //otherAssignment does not exist in Assignment
                pstmt.close();
                rs.close();
                //System.out.println("otherAssignment does not exist in Assignment");
                return false;
            }
            
            String query3 = "SELECT * FROM AssignmentGroup WHERE assignment_id=?;";
            pstmt = this.connection.prepareStatement(query3);
            pstmt.setInt(1, assignmentToGroup);
            
            rs = pstmt.executeQuery();
            if (rs.next()){
                //assignmentToGroup already has declared groups
                pstmt.close();
                rs.close();
                //System.out.println("assignmentToGroup already has declared groups");
                return false;
            }
            
            //students sorted by marks where mark != null
            String query4 = "SELECT username FROM MarkusUser NATURAL JOIN Membership NATURAL JOIN "
            + "AssignmentGroup NATURAL JOIN Result WHERE type='student' AND assignment_id=? ORDER BY mark DESC NULLS LAST, username ASC;";
            pstmt = this.connection.prepareStatement(query4);
            pstmt.setInt(1, otherAssignment);
            
            rs = pstmt.executeQuery();
            
            //System.out.println("Order of students with previous marks: ");
            ArrayList<String> students = new ArrayList<String>();
            while(rs.next()) {
                students.add(rs.getString("username"));
                //System.out.println(rs.getString("username"));
            }
            
            //System.out.println();
            
            //all students
            String query5 = "SELECT username FROM MarkusUser WHERE type='student' ORDER BY username ASC;";
            pstmt = this.connection.prepareStatement(query5);
            
            rs = pstmt.executeQuery();
            
            //System.out.println("All students: ");
            
            ArrayList<String> allStudents = new ArrayList<String>();
            while(rs.next()) {
                allStudents.add(rs.getString("username"));
                //System.out.println(rs.getString("username"));
            }
            
            //System.out.println();
            
            // removes students with grades from all students, leaving students with null grades
            for (int x=0; x<students.size(); x++){
                allStudents.remove(students.get(x));
            }
            
            // adds students with null grades to the end of students with grades
            for (int y=0; y<allStudents.size(); y++){
                students.add(allStudents.get(y));
            }
            
            //set serial sequence to start at max(group_id)
            String query6 = "SELECT setval('AssignmentGroup_group_id_seq', (SELECT MAX(group_id) FROM AssignmentGroup));";
            pstmt = this.connection.prepareStatement(query6);
            rs = pstmt.executeQuery();
            
            
            String query7 = "INSERT INTO AssignmentGroup(assignment_id, repo) VALUES (?,?);";
            String query8 = "SELECT group_id FROM AssignmentGroup WHERE repo='temp';";
            String query9 = "UPDATE AssignmentGroup SET repo=? WHERE repo='temp';";
            String query10 = "INSERT INTO Membership(username, group_id) VALUES (?,?);";
            int k = 0;
            int groupID = 0;
            for (int i=0; i<students.size(); i++){
                if (k==0){
                    //make a new group
                    
                    pstmt = this.connection.prepareStatement(query7);
                    pstmt.setInt(1, assignmentToGroup);
                    pstmt.setString(2, "temp");
                    
                    pstmt.executeUpdate();
                    
                    
                    pstmt = this.connection.prepareStatement(query8);
                    
                    rs = pstmt.executeQuery();
                    
                    if (rs.next())
                        groupID = rs.getInt("group_id");
                    
                    //System.out.println("Auto generated group_id is " + groupID);
                    
                    
                    pstmt = this.connection.prepareStatement(query9);
                    pstmt.setString(1, repoPrefix + "/group_" + Integer.toString(groupID));
                    
                    pstmt.executeUpdate();
                }
                //insert member into group
                
                //System.out.println("Inserting students " + students.get(i) + " into group " + groupID);
                
                
                pstmt = this.connection.prepareStatement(query10);
                pstmt.setString(1,  students.get(i));
                pstmt.setInt(2, groupID);
                pstmt.executeUpdate();
                k++;
                if(k==groupMax){
                    k = 0;
                }
            }
            
            pstmt.close();
            rs.close();
            
            ////////////////////////////////////////////////////////////
            //System.out.println("After insertion,  Membership: ");
            //pstmt = this.connection.prepareStatement("select * from Membership;");
            //rs = pstmt.executeQuery();
            //while(rs.next()) {
            //System.out.println(rs.getString("username"));
            //System.out.println(rs.getInt("group_id"));
            //}
            ////////////////////////////////////////////////////////////
            
            return true;
        }
        catch (SQLException se) {
            //            System.err.println("SQL Exception." +
            //                    "<Message>: " + se.getMessage());
            se.printStackTrace();
            return false;
        }
    }
    
    public static void main(String[] args) throws SQLException{
        String url;
        Connection conn;
        PreparedStatement pStatement;
        ResultSet rs;
        String queryString;
        
        url = "jdbc:postgresql://localhost:5432/csc343h-liangz24";      // remember to change this *******
        Assignment2 a = new Assignment2();
        a.connectDB(url, "kanjosep", "");                           // remember to change this *******
        System.out.println("Executing assignGrader...");
        
        //// Test assignGrader
        //a.assignGrader(2000, "t1");
        //a.assignGrader(2001, "s1");
        //a.assignGrader(2001, "i1");
        //System.out.println();
        
        //// Test recordMember
        //System.out.println("Checking recordMember...");
        //System.out.println("Case STUDENT ALREADY IN: ");
        //a.recordMember(1000, 2000, "s1");
        //System.out.println("Case INVALID ASSIGNMENT: ");
        //a.recordMember(1003, 2000, "s3");
        //System.out.println("Case VALID: ");
        //a.recordMember(1000, 2000, "s3");
        //System.out.println("Case NOT STUDENT IN: ");
        //a.recordMember(1000, 2000, "t1");
        //System.out.println();
        
        // Test createGroup
        System.out.println("Checking createGroup...");
        a.createGroups(1001, 1000, "====");
    }
}
