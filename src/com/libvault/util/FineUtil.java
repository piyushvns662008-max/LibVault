package com.libvault.util;
// FILE: src/com/libvault/util/FineUtil.java

import java.sql.Date;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

public class FineUtil {

    public static final double FINE_PER_DAY = 5.0; // Rs 5/day after due date

    // Calculates fine as of "today" if book is not yet returned
    public static double calculateFine(Date dueDate) {
        LocalDate due = dueDate.toLocalDate();
        LocalDate today = LocalDate.now();
        long lateDays = ChronoUnit.DAYS.between(due, today);
        if (lateDays > 0) {
            return lateDays * FINE_PER_DAY;
        }
        return 0.0;
    }

    // Calculates fine when book IS returned (based on actual return date)
    public static double calculateFine(Date dueDate, Date returnDate) {
        LocalDate due = dueDate.toLocalDate();
        LocalDate ret = returnDate.toLocalDate();
        long lateDays = ChronoUnit.DAYS.between(due, ret);
        if (lateDays > 0) {
            return lateDays * FINE_PER_DAY;
        }
        return 0.0;
    }
}
