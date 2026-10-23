

<%@page import="caisse.MvtCaisseCpl"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="java.util.Map" %> 
<%@ page import="java.util.HashMap" %>
<%@ page import="client.Client" %>
<%@ page import="utilitaire.*" %>
<% 
    String[] tId;
    Client cl = null;
    String idClient=null;
    try{ 
    MvtCaisseCpl t = new MvtCaisseCpl();
    tId = request.getParameterValues("ids");
    idClient = request.getParameter("idClient");
    if(tId!=null){
        cl = t.getClientMemeByFacture(tId,null);
        idClient = cl.getId();
    }
  
    String etat = request.getParameter("etat");
    if(etat == null) etat = "";
    t.setNomTable( t.getNomTable().concat(etat) );
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"id", "daty", "reference","tiers","designation","idCaisseLib","credit","soldecredit", "etatLib"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Paiement facture vente par caisse");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    //pr.setAWhere(" and etat>7");
    if(idClient!=null && !idClient.equals("")){
        //pr.getFormu().getChamp("idTiers").setDefaut(cl.getId());
        pr.setAWhere(" and idTiers = '"+idClient+"' and soldecredit>0 and etat>=8");
    }
    pr.setLien((String) session.getValue("lien"));
    /*pr.setApres("caisse/paiement-mvtcaisse.jsp");
    pr.getFormu().getChamp("idTiers").setLibelle("Client");
    pr.getFormu().getChamp("idTiers").setAutre("readonly");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("designation").setLibelle("d&eacute;signation");
        pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setLibelle("Date max");*/
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    
    Map<String,String> lienTab=new HashMap();
    lienTab.put("modifier",pr.getLien() + "?but=caisse/mvt/mvtCaisse-modif.jsp");  
    pr.getTableau().setLienClicDroite(lienTab);

    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=caisse/mvt/mvtCaisse-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"id","date", "R&eacute;f&eacute;rence" ,"client","d&eacute;signation","Caisse","Cr&eacute;dit","Solde cr&eacute;dit", "&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String[] etatAffiche = {"Tous","Cr&eacute;&eacute;","Valid&eacute;","Annul&eacute;"};
    String[] etatPasse = {"","_annule","_cree","_valider"};
%>

<div class="content-wrapper">
        <h1 class=""><%= pr.getTitre() %></h1>
    <section class="content">

        <div class="row">
            <div class="col-lg-12">
                <form action="<%= pr.getLien() %>?but=<%= pr.getApres() %>" method="post">
                    <div class="col-md-4 nopadding">
                        <div class="d-flex" style="align-items: end;gap: 8px;">
                            <div class="form-input w-100">
                                <label for="etat" class="input-label">Etat</label>
                                <select name="etat" id="etat" class="form-control">
                                    <%
                                        for(int i=0; i<etatAffiche.length; i++){
                                            String selected = "";
                                            if(request.getParameter("etat")!=null && request.getParameter("etat").compareToIgnoreCase(etatPasse[i])==0){
                                                selected = "selected";
                                            }
                                    %>
                                    <option value="<%=etatPasse[i]%>" <%=selected%>><%=etatAffiche[i]%></option>
                                    <%
                                        }
                                    %>
                                </select>
                            </div>
                            <input type="submit" value="Consultez" class="btn btn-small btn-primary my-2">
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <div class="col-md-12 nopadding">
            <%
                out.println(pr.getTableauRecap().getHtml());
            %>
        </div>

        <br>
        <form action="<%=pr.getLien()%>?but=vente/apres-paiement.jsp" method="post" name="facturevente" id="facturevente">
            <input type="hidden" name="ids_vente" value="<%= (tId != null ? String.join(";", tId) : "") %>" />
            <%
                pr.getTableau().setNameActe("liaisonFactureCaisse");
               
            %>
            <% if (pr.getTableau().getHtmlWithCheckbox() != null) {
                 out.println(pr.getTableau().getHtmlWithCheckbox());
            }%>
            <input type="hidden" name="acte" id="acte" value="">
            <input type="hidden" name="but" value="vente/paiement-multiple-facture2.jsp" />
        </form>
        <%
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<% } catch (Exception e) { %>
    <script>
        alert("<%= e.getMessage().replace("\"", "\\\"").replace("\n", "") %>");
        history.back();  
    </script>
    <% e.printStackTrace(); %>
<% } %>
<script>
window.onload = function() {
    const btn = document.getElementsByName("Submit2")[0];
    btn.removeAttribute("onclick");
    btn.addEventListener("click", function (e) {
        e.preventDefault();
        document.getElementById("acte").value = "liaisonFactureCaisse";
        btn.closest("form").submit();
    });
};
</script>



