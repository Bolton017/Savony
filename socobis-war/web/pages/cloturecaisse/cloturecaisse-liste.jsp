<%@page import="affichage.*"%>
<%@page import="prevision.*"%>
<%@page import="user.*"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="caisse.ClotureCaisseCPL" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="annexe.Point" %>

<%
    try{
        ClotureCaisseCPL prev = new ClotureCaisseCPL();
        prev.setNomTable("CLOTURECAISSE_CPL");
        String[] intervalles = { "daty" };
        String[] criteres = { "id",  "daty" };
        String[] libEntete = { "id", "daty", "remarque", "etatLib" };
        String[] libEnteteAffiche = { "ID", "Date",  "Remarque", "&Eacute;tat" };
        PageRecherche pr = new PageRecherche( prev, request, criteres, intervalles, 3, libEntete, libEntete.length );

        pr.setTitre("Liste des cl&ocirc;tures de caisse");
        pr.setUtilisateur((UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        String etat = request.getParameter("etat");
        if(etat!=null && !etat.isEmpty() ) pr.setAWhere(" and etat = '"+etat+"'");
        pr.setApres("cloturecaisse/cloturecaisse-liste.jsp");
        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);

        Map<String,String> lienTab=new HashMap();
        lienTab.put("modifier",pr.getLien() + "?but=cloturecaisse/cloturecaisse-saisie.jsp");
        pr.getTableau().setLienClicDroite(lienTab);

        pr.getFormu().getChamp("id").setLibelle("ID");
        pr.getFormu().getChamp("daty1").setLibelle("Date D&eacute;but");
        pr.getFormu().getChamp("daty2").setLibelle("Date Fin");
        pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.datetostring(Date.valueOf(LocalDate.now().minusDays(7))));
        pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());

        String awhere = "";
        System.out.println("ETAT: " + request.getParameter("etat"));
        if(request.getParameter("etat")!=null && request.getParameter("etat").compareToIgnoreCase("")!=0) {
            awhere += " and etat >= " + request.getParameter("etat");
        }
        pr.setAWhere(awhere);

        //Definition des lienTableau et des colonnes de lien
        String lienTableau[] = {pr.getLien() + "?but=cloturecaisse/cloturecaisse-fiche.jsp"};
        String colonneLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        pr.getTableau().setLienFille("cloturecaisse/inc/cloture-details.jsp&id=");

        String[] etatAffiche = { "Tous","Cr&eacute;&eacute;e(s)","Vis&eacute;e(s)"};
        String[] etatPasse = { "","1","11" };
%>

<script>
    function changerEtat() {
        document.cloturecaisse.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="cloturecaisse" id="cloturecaisse">
            <%
                //String libelles[]={" ","Nombre"};
                //pr.getTableauRecap().setLibeEntete(libelles);
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="row col-md-12 nopadding">
                <div class="col-md-2 nopadding">
                    &Eacute;tat :
                    <select name="etat" class="champ form-control" id="etat" onchange="changerEtat()">
                        <% for(int i = 0; i < etatAffiche.length; i++){ %>
                            <%
                                String paramEtat = request.getParameter("etat");
                                String isSelected = "";
                                if(paramEtat == null || paramEtat.isEmpty()) {
                                    if(i == 0) isSelected = "selected";
                                } else if(paramEtat.equals(etatPasse[i])) {
                                    isSelected = "selected";
                                }
                            %>
                            <option value="<%= etatPasse[i] %>" <%= isSelected %>><%= etatAffiche[i] %></option>
                        <% } %>
                    </select>
                </div>
                <div class="col-md-4"></div>
            </div>
        </form>
        <% out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>


<% }catch(Exception e){
    e.printStackTrace();
}%>