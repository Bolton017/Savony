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
        pr.setTitre("Dupliquer budget");
        pr.setUtilisateur((UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
    
        pr.setApres("budget/budget-liste.jsp");
        String[] colSomme = {"debit", "credit"};
        pr.creerObjetPage(libEntete, colSomme);
        
        Map<String,String> lienTab=new HashMap();
        lienTab.put("modifier",pr.getLien() + "?but=budget/budget-modif.jsp");
        pr.getTableau().setLienClicDroite(lienTab);
        
        pr.getFormu().getChamp("id").setLibelle("ID");
        pr.getFormu().getChamp("compte").setLibelle("Compte de regroupement");
        pr.getFormu().getChamp("daty1").setLibelle("Date D&eacute;but");
        pr.getFormu().getChamp("daty2").setLibelle("Date Fin");
        pr.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
    
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
        <form action="<%=pr.getLien()%>?but=budget/apresBudget.jsp" method="post" name="budget" id="budget">
            <input type="hidden" name="acte" value="validerMultiple">
            <div class="row">
                <div class="col-md-4 form-input">
                    <label class="col-md-12 nopadding fontinter labelinput" for="Mois">Mois</label>
                    <span class="col-md-12 row nopadding">
                        <select name="mois" class="form-control" id="mois" data-parsley-id="16" tabindex="7">
                            <% for(int i=0;i<affMois.length;i++){
                                if(Utilitaire.getMois(Utilitaire.dateDuJour()).compareToIgnoreCase(valMois[i])==0){
                            %>
                            <option value="<%= valMois[i]%>" selected><%= affMois[i]%></option>
                            <% }else{ %>
                            <option value="<%= valMois[i]%>"><%= affMois[i]%></option>
                            <% } }%>
                        </select>
                    </span>
                </div>
                <div class="col-md-4 form-input">
                    <label class="col-md-12 nopadding fontinter labelinput" for="Année">Ann&eacute;e</label>
                    <span class="col-md-12 row nopadding">
                        <input name="annee" type="text" class="form-control" id="annee" value="<%= Utilitaire.getAnnee(Utilitaire.dateDuJour())%>" onblur="calculer('annee')" oninput="if(this.value !== '') { synchro(this,checkbox.id) }" data-parsley-id="18" tabindex="8">
                    </span>
                </div>
                <div class="col-md-4 form-input">
                    <label class="col-md-12 nopadding fontinter labelinput" for="recurence">R&eacute;curence</label>
                    <span class="col-md-12 row nopadding"><input name="recurence" type="text" class="form-control" id="recurence" value="1" >
                    </span>
                </div>
            </div>
        <%
            String redirection = "budget/budget-liste-choix.jsp";
            out.println(pr.getTableau().getHtmlWithCheckbox());
        %>
            <input name="acte" type="hidden" id="nature" value="declarerVente">
            <input name="bute" type="hidden" id="bute" value="<%=redirection%>">
        </form>
        <%
            out.println(pr.getBasPage());
        %>
    </section>
</div>


<% }catch(Exception e){
    e.printStackTrace();
}
%>

