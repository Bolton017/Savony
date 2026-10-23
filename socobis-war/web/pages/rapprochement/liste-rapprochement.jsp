<%@page import="rapprochement.RapprochementBC"%>
<%@page import="affichage.*"%>
<%@page import="prevision.*"%>
<%@page import="user.*"%>
<%@ page import="java.util.Map" %> 
<%@ page import="java.util.HashMap" %>
<%@ page import="rapprochement.RapprochementDBMere" %>
<%@ page import="rapprochement.RapprochementDBMereLib" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="utilitaire.Utilitaire" %>

<%

    try{
        RapprochementDBMereLib rapprochement = new RapprochementDBMereLib();
        String[] intervalles = {"daty"};
        String[] criteres = { "daty","idbanque"};
        String[] libEntete = {"id", "daty","idbanquelib","valeur","etatlib"};
        String[] libEnteteAffiche = {"ID", "Date","Banque","Valeur","&Eacute;tat"};
        PageRecherche pr = new PageRecherche( rapprochement, request, criteres, intervalles, 3, libEntete, libEntete.length );
    
        pr.setTitre("Liste des rapprochements");
        pr.setUtilisateur((UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));

        Liste[] liste=new Liste[1];
        TypeObjet typeContrat = new TypeObjet();
        typeContrat.setNomTable("BANQUE_COMPTA");
        liste[0]=new Liste("idbanque",typeContrat,"val","desce");
        pr.getFormu().changerEnChamp(liste);

        pr.setApres("rapprochement/liste-rapprochement.jsp");
        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);


        //pr.getFormu().getChamp("id").setLibelle("ID");
        pr.getFormu().getChamp("daty1").setLibelle("Date de d&eacute;but");
        pr.getFormu().getChamp("daty1").setDefaut(Utilitaire.dateDuJour());
        pr.getFormu().getChamp("daty2").setLibelle("Date de fin");
        pr.getFormu().getChamp("daty2").setDefaut(Utilitaire.dateDuJour());
        pr.getFormu().getChamp("idbanque").setLibelle("Banque");
    
        //Definition des lienTableau et des colonnes de lien
        String lienTableau[] = {pr.getLien() + "?but=rapprochement/fiche-rapprochement.jsp"};
        String colonneLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>  


<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="vente" id="vente">
            <%
          //      String libelles[]={"ID", "Date","ID sous &eacute;criture","ID Relev&eacute; d&eacute;tail", "Valeur sous &eacute;criture","Valeur relev&eacute; d&eacute;tail"};
            //    pr.getTableauRecap().setLibeEntete(libelles);
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


<% }catch(Exception e){
    e.printStackTrace();
}
%>

