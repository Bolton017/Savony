package fabrication;

import chatbot.AiTabDesc;
import chatbot.ClassIA;
import utils.ConstanteAsync;

import java.sql.Date;

@AiTabDesc("La structure de ma table de fabrication est comme ceci: ")
public class FabricationFilleCpl2 extends FabricationFilleCpl implements ClassIA {
    Date daty;
    double revient;

    public FabricationFilleCpl2() throws Exception {
        super.setNomTable("FABRICATIONFILLECPL2");
    }

    @Override
    public String getNomTableIA() {
        return "FABRICATIONFILLECPL2";
    }
    @Override
    public String getUrlListe() {
        return "/savonnerie/pages/module.jsp?but=fabrication/fabrication-liste.jsp&currentMenu=MENUDYN0304009";
    }
    @Override
    public String getUrlAnalyse() {
        return "/savonnerie/pages/module.jsp?but=fabrication/analyseFabrication-details.jsp";
    }
    @Override
    public String getUrlSaisie() {
        return "/savonnerie/pages/module.jsp?but=fabrication/fabrication-saisie.jsp&currentMenu=MENUDYN0304008";
    }
    @Override
    public ClassIA getClassListe() {
        return this;
    }
    @Override
    public ClassIA getClassAnalyse() {
        return this;
    }

    @Override
    public ClassIA getClassSaisie() {
        try {
            return new FabricationFille();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

	public double getRevient() {
		return this.revient;
	}

	public void setRevient(double revient) {
		this.revient = revient;
	}
}
