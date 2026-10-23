<%--
    Document   : avance-fiche
    Created on : 10 sept. 2022, 15:44:39
    Author     : Sambatra Rakotondrainibe
--%>
<%@page import="utilitaire.ConstanteEtat"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="affichage.PageConsulte"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="paie.avance.Avance" %>
<%
    String dossier = "op";
    String pageActuel = "paie/avance/avance-fiche.jsp";

    Avance avance = new Avance();
    avance.setNomTable("AVANCE_LIB");
    PageConsulte pc = new PageConsulte(avance, request, (user.UserEJB) session.getValue("u"));
        pc.getChampByName("daty").setVisible(false);

        pc.getChampByName("idpersonnel").setLibelle("Personnel");
        pc.getChampByName("nbremboursement").setLibelle("Nombre de remboursements");
//        pc.getChampByName("daty").setLibelle("Date");
        pc.getChampByName("dateavance").setLibelle("Date d'Avance");
    pc.getChampByName("idtypeavance").setLibelle("Type d'Avance");
    pc.getChampByName("interet").setLibelle("Int&eacute;r&ecirc;t (%)");
    pc.getChampByName("montant").setLibelle("Montant(Ar)");
    pc.getChampByName("etat").setLibelle("&Eacute;tat");

	pc.setTitre("Fiche De l'avance");
    Avance base = (Avance) pc.getBase();

    Avance lv=new Avance();
    lv.setNomTable("AVANCE_LIB2");

    String libEntete[] = {"id", "daty", "dateavance","idtypeavancelib", "idpersonnel","matricule", "montant","nbremboursement","etatlib"};

    String listeCrt[] = {};
    String listeInt[] = {};
    lv.setId(null);
    PageRecherche pr = new PageRecherche(lv, request,listeCrt, listeInt, 0, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setAWhere(" and matricule=(select matricule from Avance_lib2 where id='"+request.getParameter("id")+"') order by dateavance desc");

    pr.setApres("paie/avance/avance-liste.jsp");
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    String lien = (String) session.getValue("lien");

%>
<style>
    .pagination-bas-page {
        border: none;
        border-top: 1px solid var(--Border);
    }
</style>
<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=paie/avance/avance-liste.jsp"%>> <i class="fa fa-angle-left"></i></a>Fiche De l'Avance</h1>
    <div class="row m-0">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <a class="btn btn-primary pull-right"  href="<%=(String) session.getValue("lien") + "?but=paie/avance/remboursement-saisie.jsp&id=" + request.getParameter("id")%>" style="margin-right: 10px">Plan de remboursement</a>
                            <% if(base.getEtat() == ConstanteEtat.getEtatCreer()) { %>
                            <a class="btn btn-secondary pull-right"  href="<%=(String) session.getValue("lien") + "?but=paie/avance/avance-modif.jsp&id=" + request.getParameter("id")%>" style="margin-right: 10px">Modifier</a>
                            <a class="btn btn-secondary pull-right"  href="<%=(String) session.getValue("lien") + "?but=apresTarif.jsp&id=" + request.getParameter("id")%>&acte=valider&bute=paie/avance/avance-liste.jsp&classe=paie.avance.Avance" style="margin-right: 10px">Viser</a>
                            <a class="btn btn-danger pull-left"  href="<%=(String) session.getValue("lien") + "?but=apresTarif.jsp&id=" + request.getParameter("id")%>&acte=delete&bute=paie/avance/avance-liste.jsp&classe=paie.avance.Avance" style="margin-right: 10px">Supprimer</a>
                            <% }else if(base.getEtat() == ConstanteEtat.getEtatValider()){ %>
                            <%-- <a class="btn btn-success pull-right"  href="<%=(String) session.getValue("lien") + "?but=apresPlanRemboursement.jsp&id=" + request.getParameter("id")%>&acte=solderTous&bute=paie/avance/avance-liste.jsp" style="margin-right: 10px">Tout payer</a>                         --%>
                            <% } %>
                            <a class="btn btn-tertiary pull-right" href="<%= (String) session.getValue("lien") + "?but=pageupload.jsp&id=" + request.getParameter("id") + "&dossier=" + dossier + "&nomtable=ATTACHER_FICHIER&procedure=GETSEQ_ATTACHER_FICHIER&bute=" + pageActuel + "&id=" + request.getParameter("id") %>" style="margin-right: 10px;">Attacher Fichier</a>
                        </div>
                        <br/>
                        <%  String lienTableau[] = {pr.getLien() + "?but=paie/avance/avance-fiche.jsp"};
                            String colonneLien[] = {"id"};
                            pr.getTableau().setLien(lienTableau);
                            pr.getTableau().setColonneLien(colonneLien);
                            String libEnteteAffiche[] =  {"ID", "Date de l'avance","Type de l'avance", "Personnel","Matricule", "Montant(Ar)", "Nombre Remboursement","&Eacute;tat"};
                            pr.getTableau().setLibelleAffiche(libEnteteAffiche);

                        %>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row m-0">
        <div class="col-md-6 nopadding">
            <div class="box-fiche">
                <div class="box nopadding">
                    <div class="listTableau">
                    <div class="box-body table-responsive no-padding">
                        <div id="selectnonee">
                            <table width="100%" border="0" align="center" cellpadding="3" cellspacing="3" class="table table-striped table-hover table-bordered">
                                <thead>
                                <tr class="head">
                                    <th width="11%" align="center" valign="top" class='contenuetable'>ID</th>
                                    <th width="11%" align="center" valign="top" class='contenuetable'>Date de l'avance</th>
                                    <th width="11%" align="center" valign="top" class='contenuetable'>Type de l'avance</th>
                                    <th width="11%" align="center" valign="top" class='contenuetable'>Personnel</th>
                                    <th width="11%" align="center" valign="top" class='contenuetable'>Matricule</th>
                                    <th width="11%" align="center" valign="top" class='contenuetable'>Montant(Ar)</th>
                                    <th width="11%" align="center" valign="top" class='contenuetable'>Nombre de remboursement</th>
                                    <th width="11%" align="center" valign="top" class='contenuetable'>&Eacute;tat</th>
                                </tr>
                                </thead>
                                <tbody>
                                <% for(int ia=0;ia<pr.getListe().length;ia++) { Avance avc=(Avance)pr.getListe()[ia];%>
                                <% if(avc.getId().equalsIgnoreCase(request.getParameter("id"))) { %>
                                <tr style="">
                                    <td width="11%" align="left"><%= avc.getId() %></td>
                                    <td width="11%" align="left"><%= Utilitaire.formatterDatySql(avc.getDateAvance()) %></td>
                                    <td width="11%" align="left"><%= avc.getIdtypeavancelib() %></td>
                                    <td width="11%" align="left"><%= avc.getIdpersonnel() %></td>
                                    <td width="11%" align="left"><%= avc.getMatricule() %></td>
                                    <td width="11%" align="right"><%= Utilitaire.formaterAr(avc.getMontant()) %></td>
                                    <td width="11%" align="right"><%= avc.getNbremboursement() %></td>
                                    <td width="11%" align="left"><%= avc.getEtatlib() %></td>
                                </tr>
                                <% continue; } %>
                                <tr onmouseover="this.style.backgroundColor='#EAEAEA'" onmouseout="this.style.backgroundColor=''" style="">
                                    <td width="11%" align="left"><a href="module.jsp?but=paie/avance/avance-fiche.jsp&amp;id=<%= avc.getId() %>"><i class="glyphicon glyphicon-list-alt"></i></a> </td>
                                    <td width="11%" align="left"><%= Utilitaire.formatterDatySql(avc.getDateAvance()) %></td>
                                    <td width="11%" align="left"><%= avc.getIdtypeavancelib() %></td>
                                    <td width="11%" align="left"><%= avc.getIdpersonnel() %></td>
                                    <td width="11%" align="left"><%= avc.getMatricule() %></td>
                                    <td width="11%" align="right"><%= Utilitaire.formaterAr(avc.getMontant()) %></td>
                                    <td width="11%" align="right"><%= avc.getNbremboursement() %></td>
                                    <td width="11%" align="left"><%= avc.getEtatlib() %></td>
                                </tr>
                                <% } %>
                                </tbody>
                            </table>
                            <%
                                out.println(pr.getBasPage());

                            %>
                        </div>
                    </div>
                </div>

                </div>
            </div>
        </div>
    </div>
    <%=pc.getHtmlAttacherFichier()%>
</div>
