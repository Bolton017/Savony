<%@page import="client.Client"%>
<%@page import="affichage.PageRecherche"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<% try {
    Client t = new Client();
    String[] listeCrt = {};
    String[] listeInt = {};
    String[] libEntete = {"nom","payeur", "telephone", "adresse"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getAttribute("u"));
    String lien = (String) session.getAttribute("lien");
    pr.setLien(lien);
    pr.creerObjetPage(libEntete, null);

    String[] libEnteteAffiche = {"Nom","Magasin","T&eacute;l&eacute;phone","Adresse"};
    String[] lienTableau = {pr.getLien() + "?but=mobile/menu-client.jsp"};
    String[] colonneLien = {"id"};
    String[] attLien = {"idClient"};

    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attLien);
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);

    // Définir une image par défaut si on veut inclure les images sur la liste
    pr.setImageDefaut(request.getContextPath() + "/assets/img/woman.jpg");
    // Masquer les noms des colonnes sur mobile. Exemple : Avec la colonne : "Nom : John Doe" ; Sans la colonne : "John Doe"
    // pr.setVisibleColMobile(false);

    // Pour rendre
    pr.setCssBoxExtraMobile("facture-box");
    // Personnaliser le format du titre en utilisant les attributs disponibles : ex : Client ID : CLI0002415 -> Client ID : {id}
    pr.setFormatTitre("{id} - {nom}");
%>
<div class="content-wrapper">
    <jsp:include page="/pages/elements/headerMobile.jsp">
        <jsp:param name="titre" value="Liste des Clients"/>
    </jsp:include>
    <%=pr.getHtmlSearchMobile()%>
    <%=pr.getHtmlInterfaceMobile()%>
    <div class="fab-wrapper">
        <div class="menu" id="menu">
            <a href="<%= lien + "?but=mobile/saisie-client.jsp"%>" class="menu-item">
                <i class="material-symbols-rounded">person_add</i>
                <span>Nouvelle client</span>
            </a>
            <a href="<%= lien + "?but=mobile/liste-prospection.jsp"%>" class="menu-item">
                <i class="material-symbols-rounded">person_search</i>
                <span>Prospection</span>
            </a>
            <a href="<%= lien + "?but=mobile/liste-historique.jsp"%>" class="menu-item">
                <i class="material-symbols-rounded">history</i>
                <span>Historique</span>
            </a>
        </div>
        <button class="fab-button" id="fabButton" aria-expanded="false" aria-label="Ouvrir le menu">
            <i class="material-symbols-rounded">add</i>
        </button>
    </div>
</div>
<% } catch (Exception e) {
    e.printStackTrace();  %>
    <script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();</script>
<% }%>
