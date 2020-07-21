from microsim.population import NHANESDirectSamplePopulation
from microsim.dementia_model import DementiaModel
from microsim.outcome import OutcomeType
from microsim.outcome_model_type import OutcomeModelType



def runParameters(inputTuple):
    linear = inputTuple[0]
    quadratic = inputTuple[1]
    # get dataframe on dementia indidcne
    # calculate incidence by age 
    demModel = DementiaModel(linear, quadratic)
    pop = NHANESDirectSamplePopulation(n=40000, year=1999)
    pop._outcome_model_repository._models[OutcomeModelType.DEMENTIA] = demModel
    pop.advance_multi_process(20)
    
    incidence = pop.get_raw_incidence_by_age(OutcomeType.DEMENTIA)
    predIncidence = .084*np.exp(0.142 * (incidence.index-60))
    
    incidenceUnder90 = incidence[:90]
    # compare to brookmeu
    predIncidence = .084*np.exp(0.142 * (incidenceUnder90.index-60))
    
    mse = ((incidenceUnder90-predIncidence)**2).sum()

    return (incidence, mse, linear, quadratic)
    

