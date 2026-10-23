package rapport.mail;

import bean.CGenUtil;
import rapport.mapping.CRContent;
import rapport.utilitaire.UtilitaireCR;
import utilitaire.UtilDB;

import java.sql.Connection;
import java.sql.Date;

public class PageMail {

    private String Objet;

    public String getObjet() {
        return Objet;
    }

    public void setObjet(String objet) {
        Objet = objet;
    }

    public MailContent[] allMailContent(Connection c)throws Exception{

        if(c==null){
            c = new UtilDB().GetConn();
        }

        CRContent crContent = new CRContent();
        CRContent[] crContents = (CRContent[]) CGenUtil.rechercher(crContent, null, null, c, " order by id asc");

        MailContent[] mailContents = new MailContent[crContents.length];
        for (int i = 0; i < crContents.length; i++) {
            mailContents[i] = MailContent.transformerCRtoMail(crContents[i], c);
        }

        return mailContents;
    }

    public String genererPageMail(int nature, Date daty, Connection c) throws Exception{

        if(c==null){
            c = new UtilDB().GetConn();
        }

        MailContent[] mailContents = this.allMailContent(c);

        String page = this.genererPageMail(mailContents, nature, daty, c);

        return page;
    }

    public String genererPageMail(MailContent[] mailContents, int nature, Date daty, Connection c) throws Exception{

        if(c==null){
            c = new UtilDB().GetConn();
        }

        String page = UtilitaireCR.pageEntete();

        for (int i = 0; i < mailContents.length; i++) {
            page += mailContents[i].genererMailContent(nature, daty, c);
        }

        page += UtilitaireCR.basPage();
        return page;
    }
}
