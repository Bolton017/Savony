<%@page import="paie.employe.EnfantPersonnelCpl"%>
<%@page import="bean.TypeObjet"%>
<%@page import="affichage.Liste"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="user.UserEJB" %>
<%@ page import="historique.MapUtilisateur" %>

<%
    try{
    EnfantPersonnelCpl dr = new EnfantPersonnelCpl();
    UserEJB ue = (UserEJB) session.getValue("u");
    EnfantPersonnelCpl pers = new EnfantPersonnelCpl();

    MapUtilisateur map = ue.getUser();

    String listeCrt[] = {"id","nom","dateNaissance", "matricule", "age"};
    String listeInt[] = {"dateNaissance"};
    String libEntete[] = {"id","nom","dateNaissance", "matricule", "age"};
    PageRecherche pr = new PageRecherche(dr, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));

    pr.setApres("paie/employe/enfantpersonne-liste.jsp");
    String[] colSomme = {};
    pr.getFormu().getChamp("id").setLibelle("ID");
    pr.getFormu().getChamp("nom").setLibelle("Nom");
    pr.getFormu().getChamp("dateNaissance1").setLibelle("Date de naissance min");
    pr.getFormu().getChamp("dateNaissance2").setLibelle("Date de naissance max");
    pr.getFormu().getChamp("matricule").setLibelle("Matricule");
    pr.getFormu().getChamp("age").setLibelle("Age");
    pr.creerObjetPage(libEntete, colSomme);
   // String enteteRecap[] = {"","Nombre","Somme de droit de cong&eacute"};
    //pr.getTableauRecap().setLibeEntete(enteteRecap);
    String lienTableau[] = {pr.getLien() + "?but=paie/employe/enfantpersonne-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"Id","Nom","date de naissance", "Matricule", "Age"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>

<script>
    function changerDesignation() {
        document.getElementById("personnel").submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1>Liste des enfants</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=paie/employe/enfantpersonne-liste.jsp" method="post" name="personnel" id="personnel">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            
        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<%}catch(Exception e){
    e.printStackTrace();
}%>
