<%--
  Created by IntelliJ IDEA.
  User: maroussia
  Date: 2025-05-07
  Time: 10:35
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="vente.Carton" %>
<%@ page import="bean.CGenUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Récupération des paramètres
    String barcode = request.getParameter("barcode");
    String lien = (String) session.getAttribute("lien");
    String bute = request.getParameter("bute");

    // Valeur par défaut (utiliser le code-barres comme ID)
    String idToUse = barcode;

    // Recherche de l'ID du carton si un code-barres a été fourni
    if (barcode != null && !barcode.trim().isEmpty()) {
        try {
            // Création d'un nouvel objet Carton
            Carton carton = new Carton();
            // Attribution du numéro de code-barres à l'objet carton
            carton.setNumero(barcode);

            // Recherche du carton dans la base de données
            Object[] cartons = CGenUtil.rechercher(carton, null, null, "");

            // Vérification si un carton a été trouvé
            if (cartons != null && cartons.length > 0) {
                // Récupération du premier carton trouvé
                carton = (Carton) cartons[0];
                // Utilisation de l'ID du carton pour la redirection
                idToUse = String.valueOf(carton.getId());
                System.out.println("Carton trouvé, ID: " + idToUse);
            } else {
                System.out.println("Aucun carton trouvé pour le code: " + barcode);
            }
        } catch (Exception e) {
            System.err.println("Erreur lors de la recherche du carton: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Construction de l'URL de redirection
    String redirectURL = lien + "?but=" + bute + "&id=" + idToUse;

    // Redirection
    response.sendRedirect(redirectURL);
%>