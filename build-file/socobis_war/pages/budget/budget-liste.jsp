<%@page import="affichage.*"%>
<%@page import="prevision.*"%>
<%@page import="user.*"%>
<%@ page import="java.util.Map" %> 
<%@ page import="java.util.HashMap" %>
<%@ page import="utilitaire.Utilitaire" %>

<%

    try{
        PrevisionComplet prev = new PrevisionComplet();
        prev.setNomTable("PREVISION_CPL");
        String[] intervalles = {"daty"};
        String[] criteres = {"id", "designation", "daty", "compte"};
        String[] libEntete = {"id", "daty", "designation", "compte",  "debit", "credit","moislib","annee","idservicelib"};
        String[] libEnteteAffiche = {"id","Date", "D&eacute;signation", "Compte de regroupement", "D&eacute;pense", "Recette","Mois","Ann&eacute;e","D&eacute;partement"};
        PageRecherche pr = new PageRecherche( prev, request, criteres, intervalles, 3, libEntete, libEntete.length );
        pr.setAWhere(" AND id like 'BUDG%' order by daty desc");
        pr.setTitre("Liste budget");
        pr.setUtilisateur((UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
    
        pr.setApres("budget/budget-liste.jsp");
        String[] colSomme = {"debit", "credit"};
        pr.creerObjetPage(libEntete, colSomme);
        
        Map<String,String> lienTab=new HashMap();
        lienTab.put("modifier",pr.getLien() + "?but=budget/budget-modif.jsp");
        pr.getTableau().setLienClicDroite(lienTab);
        
        pr.getFormu().getChamp("id").setLibelle("ID");
        pr.getFormu().getChamp("daty1").setLibelle("Date D&eacute;but");
        pr.getFormu().getChamp("daty2").setLibelle("Date Fin");
        pr.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
        pr.getFormu().getChamp("compte").setLibelle("Compte de regroupement");
    
        //Definition des lienTableau et des colonnes de lien
        String lienTableau[] = {pr.getLien() + "?but=budget/budget-fiche.jsp"};
        String colonneLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);

        String[] valMois = {"01","02","03","04","05","06","07","08","09","10","11","12"};
        String[] affMois = {"Janvier","Fevrier","Mars","Avril","Mai","Juin","Juillet","Aout","Septembre","Octobre","Novembre","Decembre"};

%>  


<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="budget" id="budget">
            <%
                String libelles[]={" ","Nombre", "D&eacute;bit", "cr&eacute;dit", "Effectif d&eacute;bit", "Effectif cr&eacute;dit"};
                pr.getTableauRecap().setLibeEntete(libelles);
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <br>
        <%
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
        %>
        <%
            out.println(pr.getBasPage());
        %>
    </section>
</div>


<% }catch(Exception e){
    e.printStackTrace();
}
%>

