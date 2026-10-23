<%@page import="facture.tr.Traite"%>
<%@ page import="user.*"%>
<%@ page import="bean.*"%>
<%@ page import="utilitaire.*"%>
<%@ page import="affichage.*"%>
<%@ page import="utils.ConstanteVente" %>
<%
    String autreparsley = "data-parsley-range='[8, 40]' required";
    Traite base = new Traite();
    base.setNomTable("TRAITE_LIB_cpl");
    PageUpdate pi = new PageUpdate(base, request, (user.UserEJB) session.getValue("u"));
    affichage.Liste[] listed = new affichage.Liste[1];
    TypeObjet o = new TypeObjet();
    o.setNomTable("banque");
    listed[0] = new Liste("banque", o, "VAL", "id");
    listed[0].setDefaut(request.getParameter("banque"));

//    TypeObjet obj = new TypeObjet();
//    obj.setNomTable("type_piece");
//    listed[1] = new Liste("idtypepiece",obj,"desce","id");
//    listed[1].setDefaut(request.getParameter("piece"));
    pi.getFormu().changerEnChamp(listed);

//    pi.getFormu().getChamp("tiers").setDefaut(request.getParameter("tiers"));
    pi.getFormu().getChamp("tiers").setPageAppel("choix/clientCategorieChoix.jsp");
    pi.getFormu().getChamp("tiers").setAutre("readonly");
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("dateEcheance").setLibelle("Date d'echeance");
    pi.getFormu().getChamp("idtypepiece").setVisible(false);
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("idbanque").setVisible(false);
    pi.getFormu().getChamp("Cdclt").setVisible(false);
    pi.getFormu().getChamp("idtypepiece").setDefaut(ConstanteVente.typepiecetraire);
    pi.getFormu().getChamp("typepiece").setVisible(false);
    pi.getFormu().getChamp("tierslib").setVisible(false);

    pi.setLien((String) session.getValue("lien"));
    UserEJB u = (UserEJB) session.getAttribute("u");
    pi.preparerDataFormu();
%> 

<div class="content-wrapper">
    <div class="row">
        <div class="col-md-6 col-md-offset-3">
            <div class="">
                <div class="box">
                    <h1>Modification Traite</h1>
                    <form action="<%=(String) session.getValue("lien")%>?but=apresTarif.jsp" method="post" name="traite" id="traite">
                        <%
                            out.println(pi.getFormu().getHtmlInsert());
                        %>
                        <div class="row">
                            <div class="col-md-11">
                                <button class="btn btn-warning pull-right" name="Submit2" type="submit">Enregistrer les modifications</button>
                            </div>
                            <br><br> 
                        </div>
                        <input name="acte" type="hidden" id="acte" value="update">
                        <input name="bute" type="hidden" id="bute" value="facture/traite-fiche.jsp">
                        <input name="classe" type="hidden" id="classe" value="facture.tr.Traite">
                        <input name="nomtable" type="hidden" id="nomtable" value="traite">
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    document.getElementById("tierslibelle").value = "<%= request.getParameter("tiers")%>";
</script>