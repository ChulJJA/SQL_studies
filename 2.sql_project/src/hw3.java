import java.sql.*;
import java.util.Scanner;

class StudentInfo {
    public static void PrintStudents(Connection conn, ResultSet rs) throws SQLException {
        System.out.println(rs.getString("last_name") + ", " + rs.getString("first_name"));
        System.out.println("ID: " + rs.getString("id"));

        String s = "SELECT dname FROM Majors WHERE sid = " + rs.getString("id");
        PreparedStatement p = conn.prepareStatement(s, ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
        ResultSet infos = p.executeQuery();

        if (infos.next()) {
            infos.previous();

            String output = "Major: ";
            while (infos.next()) {
                String major = infos.getString("dname");
                if (major != null) {
                    output += major;
                }
                if (infos.next()) {
                    output += ", ";
                    infos.previous();
                }
            }
            System.out.println(output);
        }

        s = "SELECT dname FROM Minors WHERE sid = " + rs.getString("id");
        p = conn.prepareStatement(s, ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
        infos = p.executeQuery();

        if (infos.next()) {
            infos.previous();

            String minorOutput = "Minor: ";
            while (infos.next()) {
                String minor = infos.getString("dname");
                if (minor != null) {
                    minorOutput += minor;
                }
                if (infos.next() == true) {
                    minorOutput += ", ";
                    infos.previous();
                }
            }
            System.out.println(minorOutput);
        }

        s = "SELECT SUM(CASE WHEN ht.grade = 'A' THEN 4.0 WHEN ht.grade = 'B' THEN 3.0 WHEN ht.grade = 'C' THEN 2.0 WHEN ht.grade = 'D' THEN 1.0 WHEN ht.grade = 'F' THEN 0.0 ELSE NULL END * c.credits) / SUM(c.credits) AS avg_gpa FROM Students s INNER JOIN HasTaken ht ON s.id = ht.sid AND s.id = "
                + rs.getString("id") + " INNER JOIN Classes c ON ht.name = c.name";
        p = conn.prepareStatement(s);
        infos = p.executeQuery();

        while (infos.next()) {
            System.out.println("GPA: " + infos.getString(1));
        }

        s = "SELECT SUM(credits) AS total_credits FROM HasTaken INNER JOIN Classes ON HasTaken.name = Classes.name AND HasTaken.grade != 'F' WHERE HasTaken.sid = "
                + rs.getString("id");
        p = conn.prepareStatement(s);
        infos = p.executeQuery();
        while (infos.next()) {
            System.out.println("Credits: " + infos.getString(1) + "\n");
        }
    }

    public static void SearchByName(Connection conn, String name) throws SQLException {
        String s = "SELECT * FROM Students WHERE first_name LIKE ? OR last_name LIKE?";
        PreparedStatement p = conn.prepareStatement(s, ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
        p.setString(1, "%" + name + "%");
        p.setString(2, "%" + name + "%");
        ResultSet rs = p.executeQuery();

        int studentsNum = 0;
        if (rs.last()) {
            studentsNum = rs.getRow();
            rs.beforeFirst();
        }
        System.out.println(studentsNum + "students found");

        while (rs.next()) {
            PrintStudents(conn, rs);
        }
    }

    public static void SearchByYear(Connection conn, String year) throws SQLException {
        String s = "SELECT s.first_name, s.last_name, s.id, SUM(c.credits) as total_credits FROM Students s JOIN HasTaken ht ON s.id = ht.sid JOIN Classes c ON ht.name = c.name AND ht.grade != 'F' GROUP BY s.id HAVING total_credits BETWEEN ? AND ?;";
        PreparedStatement p = conn.prepareStatement(s, ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);

        int minCredits = 0;
        int maxCredits = 0;
        switch (year) {
            case "Fr":
                minCredits = 0;
                maxCredits = 29;
                break;
            case "So":
                minCredits = 30;
                maxCredits = 59;
                break;
            case "Ju":
                minCredits = 60;
                maxCredits = 89;
                break;
            case "Sr":
                minCredits = 90;
                maxCredits = 1000;
                break;
        }
        p.setInt(1, minCredits);
        p.setInt(2, maxCredits);
        ResultSet rs = p.executeQuery();

        int studentsNum = 0;
        if (rs.last()) {
            studentsNum = rs.getRow();
            rs.beforeFirst();
        }
        System.out.println(studentsNum + "students found");

        while (rs.next()) {
            PrintStudents(conn, rs);
        }
    }

    public static void SearchByGPA(Connection conn, double gpa, String operator) throws SQLException {
        String s = "SELECT s.first_name, s.last_name, s.id, SUM(CASE WHEN ht.grade = 'A' THEN 4.0 WHEN ht.grade = 'B' THEN 3.0 WHEN ht.grade = 'C' THEN 2.0 WHEN ht.grade = 'D' THEN 1.0 WHEN ht.grade = 'F' THEN 0.0 ELSE NULL END * c.credits) / SUM(c.credits) AS gpa FROM Students s INNER JOIN HasTaken ht ON s.id = ht.sid INNER JOIN Classes c ON ht.name = c.name GROUP BY s.id HAVING gpa"
                + operator + "?";
        PreparedStatement p = conn.prepareStatement(s, ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
        p.setDouble(1, gpa);
        ResultSet rs = p.executeQuery();

        int studentsNum = 0;
        if (rs.last()) {
            studentsNum = rs.getRow();
            rs.beforeFirst();
        }
        System.out.println(studentsNum + "students found");

        while (rs.next()) {
            PrintStudents(conn, rs);
        }
    }

    public static void SearchByDepartment(Connection conn, String department) throws SQLException {
        String s = "SELECT d.name, COUNT(DISTINCT m.sid) AS num_students, SUM(CASE WHEN ht.grade = 'A' THEN 4.0 WHEN ht.grade = 'B' THEN 3.0 WHEN ht.grade = 'C' THEN 2.0 WHEN ht.grade = 'D' THEN 1.0 WHEN ht.grade = 'F' THEN 0.0 ELSE NULL END * c.credits) / SUM(c.credits) AS avg_gpa FROM Departments d LEFT JOIN Majors m ON d.name = m.dname LEFT JOIN HasTaken ht ON m.sid = ht.sid LEFT JOIN Classes c ON ht.name = c.name WHERE d.name = ? GROUP BY d.name HAVING COUNT(DISTINCT m.sid) > 0";
        PreparedStatement p = conn.prepareStatement(s, ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
        p.setString(1, department);
        ResultSet rs = p.executeQuery();

        if (rs.next()) {
            System.out.println("Num students: " + rs.getString("num_students"));
            System.out.println("Average GPA: " + rs.getString("avg_gpa"));
        }
    }

    public static void SearchByClass(Connection conn, String classes) throws SQLException {
        String s = "SELECT COUNT(DISTINCT sid) AS num_students FROM IsTaking WHERE name = ?";
        PreparedStatement p = conn.prepareStatement(s, ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
        p.setString(1, classes);
        ResultSet rs = p.executeQuery();

        if (rs.next()) {
            System.out.println(rs.getString("num_students") + " students currently enrolled");
        }

        String s_2 = "SELECT grade, COUNT(*) AS num_students FROM HasTaken WHERE name = ? GROUP BY grade;";
        PreparedStatement p_2 = conn.prepareStatement(s_2, ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
        p_2.setString(1, classes);
        ResultSet rs_2 = p_2.executeQuery();

        if (rs_2.next()) {
            System.out.println("Grades of previous enrollees:");
            rs_2.previous();

            while (rs_2.next()) {
                System.out.println(rs_2.getString("grade") + " " + rs_2.getString("num_students"));
            }
        }
    }

    public static void ArbitraryQuery(Connection conn, String query) throws SQLException {
        String s = query;
        PreparedStatement p = conn.prepareStatement(s);
        ResultSet rs = p.executeQuery();
        ResultSetMetaData rsmd = rs.getMetaData();

        int columnCount = rsmd.getColumnCount();
        String columns = "";
        for (int i = 1; i <= columnCount; ++i) {
            if (i == columnCount) {
                columns += rsmd.getColumnName(i);
            } else {
                columns += rsmd.getColumnName(i) + "    ";
            }
        }
        System.out.println(columns);

        while (rs.next()) {
            String output = "";

            for (int i = 1; i <= columnCount; ++i) {
                if (i == columnCount) {
                    output += rs.getString(rsmd.getColumnName(i));
                } else {
                    output += rs.getString(rsmd.getColumnName(i)) + "   ";
                }
            }
            System.out.println(output);
        }
    }

    public static void main(String args[]) throws SQLException {
        try {
            String server = args[0];
            String root = args[1];
            String password = args[2];
            Connection conn = DriverManager.getConnection("jdbc:mysql://" + server, root,
                    password);

            System.out.println("$ java uniDB " + server + " " + root + " " + password);
            System.out.println("Welcome to the university database. Queries available:");

            Scanner s = new Scanner(System.in);
            Scanner s2 = new Scanner(System.in);
            Scanner s3 = new Scanner(System.in);

            int inputInt = 0;
            float inputGPA = 0;
            String inputStr = "";

            while (inputInt != 8) {
                System.out.println("1. Search students by name.");
                System.out.println("2. Search students by year.");
                System.out.println("3. Search for students with a GPA >= threshold.");
                System.out.println("4. Search for students with a GPA <= threshold.");
                System.out.println("5. Get department statistics.");
                System.out.println("6. Get class statistics.");
                System.out.println("7. Execute an abitrary SQL query.");
                System.out.println("8. Exit the application.");
                System.out.println("Which query would you like to run (1-8)?");

                inputInt = s.nextInt();
                if (inputInt == 1) {
                    System.out.println("Please enter the name.");
                    inputStr = s2.nextLine();
                    SearchByName(conn, inputStr);
                } else if (inputInt == 2) {
                    System.out.println("Please enter the year.");
                    inputStr = s2.nextLine();
                    SearchByYear(conn, inputStr);
                } else if (inputInt == 3) {
                    System.out.println("Please enter the threshold.");
                    inputGPA = s3.nextFloat();
                    SearchByGPA(conn, inputGPA, ">=");
                } else if (inputInt == 4) {
                    System.out.println("Please enter the threshold.");
                    inputGPA = s3.nextFloat();
                    SearchByGPA(conn, inputGPA, "<=");
                } else if (inputInt == 5) {
                    System.out.println("Please enter the department.");
                    inputStr = s2.nextLine();
                    SearchByDepartment(conn, inputStr);
                } else if (inputInt == 6) {
                    System.out.println("Please enter the class name.");
                    inputStr = s2.nextLine();
                    SearchByClass(conn, inputStr);
                } else if (inputInt == 7) {
                    System.out.println("Please enter the query.");
                    inputStr = s2.nextLine();
                    ArbitraryQuery(conn, inputStr);
                } else if (inputInt != 8) {
                    System.out.println("Wrong Input");
                }
            }

            System.out.println("Goodbye.");
            conn.close();
        } catch (Exception e) {
            System.out.println(e);
        }
    }
}