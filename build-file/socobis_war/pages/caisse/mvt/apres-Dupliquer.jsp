```jsp
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="caisse.MvtCaisseCpl" %>

<%
    String lien = (String) session.getAttribute("lien");
    String id = request.getParameter("id");

    String url = null;
    String erreur = null;

    try {

        if (session.getAttribute("u") == null) {
            throw new Exception("Veuillez vous reconnecter.");
        }

        if (lien == null || lien.trim().isEmpty()) {
            throw new Exception("Le lien de redirection est introuvable.");
        }

        // Vérification de l'identifiant
        if (id == null || id.trim().isEmpty()) {
            throw new Exception(
                    "L'identifiant du mouvement de caisse est obligatoire."
            );
        }

        id = id.trim();

        MvtCaisseCpl mouvement = new MvtCaisseCpl();
        mouvement.setId(id);

        mouvement = mouvement.getMouvementCaisse(
                null,
                mouvement
        );

        if (mouvement == null) {
            throw new Exception(
                    "Le mouvement de caisse " + id + " est introuvable."
            );
        }

        String destination;


        if (mouvement.getCredit() == 0 && mouvement.getDebit() != 0) {

            destination = "caisse/mvt/mvtCaisse-saisie-sortie.jsp";

        }

        else if (mouvement.getDebit() == 0 && mouvement.getCredit() != 0) {

            destination = "caisse/mvt/mvtCaisse-saisie-entree.jsp";

        }

        else {

            throw new Exception(
                    "Mouvement de caisse invalide : "
                            + "le mouvement doit contenir soit un débit, soit un crédit."
            );
        }

        StringBuilder redirectUrl = new StringBuilder();

        redirectUrl.append(lien);

        if (lien.contains("?")) {
            redirectUrl.append("&");
        } else {
            redirectUrl.append("?");
        }

        redirectUrl
                .append("but=")
                .append(
                        URLEncoder.encode(
                                destination,
                                "UTF-8"
                        )
                );

        redirectUrl
                .append("&id=")
                .append(
                        URLEncoder.encode(
                                id,
                                "UTF-8"
                        )
                );

        redirectUrl.append("&acte=dupliquer");

        url = redirectUrl.toString();

        application.log(
                "Redirection mouvement caisse : "
                        + "id=" + id
                        + ", debit=" + mouvement.getDebit()
                        + ", credit=" + mouvement.getCredit()
                        + ", destination=" + destination
                        + ", acte=dupliquer"
        );

    } catch (Exception e) {

        application.log(
                "Erreur lors de la redirection du mouvement de caisse",
                e
        );

        erreur = e.getMessage();

        if (erreur == null || erreur.trim().isEmpty()) {
            erreur = "Impossible de rediriger ce mouvement de caisse.";
        }
    }
%>

<script type="text/javascript">

    <% if (url != null) { %>

    window.location.replace(
        <%= JSONObject.quote(url).replace("<", "\\u003c") %>
    );

    <% } else { %>

    alert(
        <%= JSONObject.quote(erreur).replace("<", "\\u003c") %>
    );

    history.back();

    <% } %>

</script>
```