package utils.csv;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CsvReader {

    // Méthode compatible Java 8 pour convertir InputStream en byte[]
    // NE PAS FERMER l'InputStream entrant
    private static byte[] inputStreamToBytes(InputStream inputStream) throws IOException {
        ByteArrayOutputStream buffer = new ByteArrayOutputStream();
        byte[] data = new byte[4096]; // Buffer de 4KB
        int bytesRead;

        // NE PAS utiliser try-with-resources sur l'InputStream entrant
        // car on ne veut pas le fermer
        while ((bytesRead = inputStream.read(data, 0, data.length)) != -1) {
            buffer.write(data, 0, bytesRead);
        }
        buffer.flush();
        byte[] result = buffer.toByteArray();
        buffer.close();

        return result;
    }

    // Méthode principale avec gestion de la réutilisation
    public static List<Map<String, String>> readCSV(InputStream inputStream, String delimiter,
                                                    int startLine, String colRequired, String[] customHeaders) throws IOException {

        // Créer une copie de l'InputStream pour ne pas affecter l'original
        byte[] bytes = copyInputStream(inputStream);

        // Utiliser la méthode qui travaille sur byte[]
        return readCSVFromBytes(bytes, delimiter, startLine, colRequired, customHeaders);
    }

    // Méthode pour copier l'InputStream sans le fermer
    public static byte[] copyInputStream(InputStream inputStream) throws IOException {
        if (inputStream == null) {
            return new byte[0];
        }

        // Vérifier si l'InputStream supporte mark/reset
        if (inputStream.markSupported()) {
            // Sauvegarder la position
            inputStream.mark(Integer.MAX_VALUE);
        }

        try {
            ByteArrayOutputStream buffer = new ByteArrayOutputStream();
            byte[] data = new byte[4096];
            int bytesRead;

            while ((bytesRead = inputStream.read(data, 0, data.length)) != -1) {
                buffer.write(data, 0, bytesRead);
            }

            buffer.flush();
            byte[] result = buffer.toByteArray();
            buffer.close();

            // Réinitialiser l'InputStream si possible
            if (inputStream.markSupported()) {
                inputStream.reset();
            }

            return result;
        } catch (IOException e) {
            throw new IOException("Erreur lors de la copie du flux", e);
        }
    }

    // Nouvelle méthode qui travaille sur byte[]
    public static List<Map<String, String>> readCSVFromBytes(byte[] bytes, String delimiter,
                                                             int startLine, String colRequired,
                                                             String[] customHeaders) throws IOException {

        if (bytes == null || bytes.length == 0) {
            return new ArrayList<>();
        }

        ByteArrayInputStream byteArrayInputStream = new ByteArrayInputStream(bytes);
        BufferedReader reader = new BufferedReader(new InputStreamReader(byteArrayInputStream, "UTF-8"));

        List<Map<String, String>> data = new ArrayList<>();
        String line;
        int currentLine = 0;
        StringBuilder multiLineBuffer = null;
        boolean started = true;

        try {
            while ((line = reader.readLine()) != null || multiLineBuffer != null) {
                if (line != null) {
                    currentLine++;

                    // Ignorer les lignes avant startLine
                    if (currentLine < startLine) {
                        continue;
                    }

                    // Gestion des champs multilignes
                    if (multiLineBuffer != null) {
                        multiLineBuffer.append("\n").append(line);

                        // Vérifier si le champ multiligne est terminé (guillemets fermés)
                        if (hasEvenQuotes(multiLineBuffer.toString())) {
                            line = multiLineBuffer.toString();
                            multiLineBuffer = null;
                        } else {
                            continue; // Continuer à accumuler les lignes
                        }
                    } else {
                        // Vérifier si c'est un début de champ multiligne
                        if (hasOddQuotes(line)) {
                            multiLineBuffer = new StringBuilder(line);
                            continue;
                        }
                    }

                    if (line.trim().isEmpty()) {
                        continue;
                    }

                    // Parser la ligne CSV PROPERLY (avec gestion des guillemets)
                    String[] values = parseLine(line, delimiter);

                    // Si on a des en-têtes personnalisés, les utiliser
                    // Sinon, utiliser la première ligne comme en-têtes
                    if (currentLine == startLine && customHeaders == null) {
                        // Utiliser la ligne startLine comme en-têtes
                        customHeaders = cleanHeaders(values);
                        continue; // Passer à la ligne suivante (première ligne de données)
                    }

                    // Vérifier si nous avons commencé la lecture des données
                    if (!started) {
                        continue;
                    }

                    // Créer la ligne de données
                    Map<String, String> row = new HashMap<>();
                    boolean hasRequiredColumn = true;

                    if (customHeaders != null) {
                        for (int i = 0; i < customHeaders.length; i++) {
                            String key = customHeaders[i];
                            String value = (i < values.length) ? cleanValue(values[i]) : "";

                            // Vérifier la colonne requise
                            if (colRequired != null && colRequired.equals(key)) {
                                if (value == null || value.trim().isEmpty()) {
                                    hasRequiredColumn = false;
                                    break;
                                }
                            }

                            row.put(key, value);
                        }
                    } else {
                        // Si pas d'en-têtes, utiliser des noms génériques
                        for (int i = 0; i < values.length; i++) {
                            row.put("col" + (i + 1), cleanValue(values[i]));
                        }
                    }

                    if (hasRequiredColumn) {
                        data.add(row);
                    } else {
                        // Arrêter la lecture si la colonne requise est vide
                        break;
                    }
                }
            }
        } finally {
            try {
                reader.close();
            } catch (IOException e) {
                // Ignorer
            }
            try {
                byteArrayInputStream.close();
            } catch (IOException e) {
                // Ignorer
            }
        }

        return data;
    }

    // Méthodes auxiliaires existantes...
    private static String[] parseLine(String line, String delimiter) {
        List<String> tokens = new ArrayList<>();
        StringBuilder currentToken = new StringBuilder();
        boolean inQuotes = false;
        char delimChar = delimiter.charAt(0);

        for (int i = 0; i < line.length(); i++) {
            char c = line.charAt(i);

            if (c == '"') {
                if (inQuotes && i + 1 < line.length() && line.charAt(i + 1) == '"') {
                    currentToken.append('"');
                    i++;
                } else {
                    inQuotes = !inQuotes;
                }
            } else if (c == delimChar && !inQuotes) {
                tokens.add(currentToken.toString());
                currentToken = new StringBuilder();
            } else {
                currentToken.append(c);
            }
        }

        tokens.add(currentToken.toString());
        return tokens.toArray(new String[0]);
    }

    private static String cleanValue(String value) {
        if (value == null) {
            return "";
        }

        value = value.trim();

        if (value.startsWith("\"") && value.endsWith("\"")) {
            value = value.substring(1, value.length() - 1);
        }

        value = value.replace("\"\"", "\"");
        return value;
    }

    private static String[] cleanHeaders(String[] headers) {
        String[] cleaned = new String[headers.length];
        for (int i = 0; i < headers.length; i++) {
            cleaned[i] = cleanValue(headers[i]);
        }
        return cleaned;
    }

    private static boolean hasEvenQuotes(String str) {
        int count = 0;
        for (int i = 0; i < str.length(); i++) {
            if (str.charAt(i) == '"') {
                if (i == 0 || str.charAt(i-1) != '\\') {
                    count++;
                }
            }
        }
        return count % 2 == 0;
    }

    private static boolean hasOddQuotes(String str) {
        return !hasEvenQuotes(str);
    }
}
