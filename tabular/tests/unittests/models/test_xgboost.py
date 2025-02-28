from autogluon.tabular.models.xgboost.xgboost_model import XGBoostModel

toy_model_params = {"n_estimators": 10}


def test_xgboost(fit_helper):
    model_cls = XGBoostModel
    model_hyperparameters = toy_model_params

    fit_helper.verify_model(model_cls=model_cls, model_hyperparameters=model_hyperparameters)


def test_xgboost_binary_enable_categorical(fit_helper):
    fit_args = dict(
        hyperparameters={XGBoostModel: {"enable_categorical": True}},
    )
    dataset_name = "toy_binary"
    fit_helper.fit_and_validate_dataset(dataset_name=dataset_name, fit_args=fit_args, refit_full=False)
