
<%@page import="paie.employe.PaieInfoPersonnelEnfantUpdate"%>
<%@page import="affichage.Liste"%>
<%@page import="bean.TypeObjet"%>
<%@page import="user.UserEJB"%>
<%@page import="affichage.PageRechercheUpdate"%>
<!--apseo lib fa le any am form ary ambany final-->
<%
    try{
        

        UserEJB u = (UserEJB) session.getAttribute("u");
        PaieInfoPersonnelEnfantUpdate a = new PaieInfoPersonnelEnfantUpdate();
        a.setNomTable("paie_info_personnel_enfant");
        String listeCrt[] = {"id", "matricule", "cturgence_nom_prenom"};
        String listeInt[] = null;
        String libEntete[] = {"id", "matricule", "cturgence_nom_prenom", "nbenfant"};

        PageRechercheUpdate pr = new PageRechercheUpdate(a, request, listeCrt, listeInt, 3, libEntete, "id");
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        pr.setApres("paie/employe/infopersonnel-modif-multiple.jsp");
        String[] colSomme = null;

        pr.setNpp(300);

        pr.creerObjetPage(libEntete, colSomme);

        int nombreLigne = pr.getTableau().getData().length;
        
        pr.getFormu().getChamp("id").setLibelle("ID");
        pr.getFormu().getChamp("matricule").setLibelle("Matricule");
        pr.getFormu().getChamp("cturgence_nom_prenom").setLibelle("Nom(s) et pr&eacute;nom(s)");
        
        pr.getFormuLigne().getChamp("matricule").setAutre("readonly");
        pr.getFormuLigne().getChamp("cturgence_nom_prenom").setAutre("readonly");
        String classe = "paie.employe.PaieInfoPersonnelEnfantUpdate";
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1>Modification du nombre d'enfants des personnels</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=paie/employe/infopersonnel-modif-multiple.jsp" method="post" name="incident" id="incident">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>

        <form action="<%=pr.getLien()%>?but=apresMultiple.jsp" id='modif-form' method="post" data-parsley-validate>
            <div class="row m-0 mb-5">
                <%
                    String libEnteteAffiche[] = {"ID","Matricule", "Nom(s) et pr&eacute;nom(s)", "Enfant(s) &agrave; charge"};
                    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
                    out.println(pr.getTableau().getHtmlWithCheckboxUpdateMultiple());
    
                %>
            </div>
            <input name="acte" type="hidden" id="nature" value="updateMultiple">
            <input name="bute" type="hidden" id="bute" value="paie/employe/infopersonnel-modif-multiple.jsp">
            <input name="classe" type="hidden" id="classe" value="<%= classe %>">
            <input name="nomtable" type="hidden" id="classe" value="paie_info_personnel">
            <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%=nombreLigne%>">
        </form>
    </section>
</div>
<%
    }catch(Exception e){
    e.printStackTrace();
}
%>