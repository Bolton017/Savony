<%-- 
    Document   : mvtCaisse-liste-non-attache
    Created on : 16 ao�t 2024, 16:07:46
    Author     : ASUS
--%>

<%@page import="caisse.MvtCaisseCpl"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="affichage.Liste" %>

<% try{
    String[] etatVal = {"%","1","11"};
    String[] etatAff = {"Tous","Cr&eacute;&eacute;", "Valid&eacute;e"};
    MvtCaisseCpl t = new MvtCaisseCpl();
    t.setNomTable("MOUVEMENTCAISSECPL_NATTACH");
    String etat = request.getParameter("etat");
    if(etat == null) etat = "%";
    String listeCrt[] = {"id", "designation", "daty","etat"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"id", "designation","idCaisseLib","idVenteDetail" , "idVirement","credit","debit", "etatlib"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste mouvement caisse non attach&eacute;");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("caisse/mvt/mvtCaisse-liste-non-attache.jsp");
    pr.getFormu().getChamp("etat").setLibelle("&Eacute;tat");
    pr.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setLibelle("Date max");

    Liste[] liste = new Liste[1];
    liste[0] = new Liste("etat");
    liste[0].ajouterValeur(etatVal, etatAff);
    pr.getFormu().changerEnChamp(liste);

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=caisse/mvt/mvtCaisse-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);

    String libEnteteAffiche[] = {"id", "d&eacute;signation","Caisse","Vente d&eacute;tail" , "Virement","Cr&eacute;dit","D&eacute;bit", "&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String[] etatAffiche = {"Tous","Annul&eacute;","Cr&eacute;e","Valid&eacute;e"};
    String[] etatPasse = {"%","ANNUL&Eacute;E","CR&Eacute;&Eacute;E","VALID&Eacute;E"};
%>
<script>
    function changerDesignation() {
        document.filtre.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="filtre">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <br>
        <form action="<%= pr.getLien()%>?but=caisse/mvt/apres-attacher-prevision.jsp" method="post">
            <input type="hidden" value="<%=request.getParameter("idPrevision")%>" name="idPrevision">
            <input type="hidden" value="<%=pr.getLien()%>" name="lien">
            <%
                pr.getTableau().setNameBoutton("Attacher");
                if(pr.getTableau().getHtmlWithCheckbox() == null)
                {
            %>      <center><h4>Aucune donn&eacute;e disponible</h4></center><%
            } else {
                out.println(pr.getTableau().getHtmlWithCheckbox());
            }
            out.println(pr.getBasPage());
        %>
        </form>
    </section>
</div>
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>
<script>
    function submitForm() {
        document.getElementById("formID").submit();
    }
</script>




