package utils;

import java.text.SimpleDateFormat;
import java.util.Date;

public class DateFormat {

    public static String formatDate(String dateInput,String in,String out) throws Exception {
        SimpleDateFormat inputFormat = new SimpleDateFormat(in);
        SimpleDateFormat outputFormat = new SimpleDateFormat(out);

        Date date = inputFormat.parse(dateInput);
        String formattedDate = outputFormat.format(date);
        return formattedDate;
    }
}
