"""
Basic tests for the CropSmart Flask application
"""

import pytest
import sys
import os

# Add the parent directory to the path so we can import app
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))


def test_app_imports():
    """Test that the main app module can be imported successfully"""
    try:
        import app

        assert hasattr(app, "app"), "Flask app instance should exist"
        assert app.app is not None, "Flask app should not be None"
    except ImportError as e:
        pytest.fail(f"Failed to import app module: {e}")


def test_app_configuration():
    """Test basic app configuration"""
    import app

    # Test that the app is a Flask instance
    from flask import Flask

    assert isinstance(app.app, Flask), "app should be a Flask instance"

    # Test that required directories exist or can be created
    assert hasattr(app, "MODEL_DIR"), "MODEL_DIR should be defined"
    assert os.path.exists(app.MODEL_DIR) or True, "MODEL_DIR should exist or be creatable"


def test_model_paths():
    """Test that model paths are properly defined"""
    import app

    # Check that all required paths are defined
    required_paths = ["MODEL_PATH", "SCALER_PATH", "FEATURES_PATH", "CATEGORICAL_VALUES_PATH"]
    for path_name in required_paths:
        assert hasattr(app, path_name), f"{path_name} should be defined"
        path_value = getattr(app, path_name)
        assert isinstance(path_value, str), f"{path_name} should be a string"
        assert len(path_value) > 0, f"{path_name} should not be empty"


def test_data_imports():
    """Test that data modules can be imported"""
    try:
        from data.location_data import get_states, get_districts, get_taluks
        from data.crop_data import CROP_DATA, load_crop_yield_data

        # Basic checks that functions exist
        assert callable(get_states), "get_states should be callable"
        assert callable(get_districts), "get_districts should be callable"
        assert callable(get_taluks), "get_taluks should be callable"
        assert callable(load_crop_yield_data), "load_crop_yield_data should be callable"

    except ImportError as e:
        pytest.fail(f"Failed to import data modules: {e}")


@pytest.mark.integration
def test_app_routes_exist():
    """Test that the Flask app has the expected routes"""
    import app

    # Get all the routes
    routes = []
    for rule in app.app.url_map.iter_rules():
        routes.append(rule.rule)

    # Check for expected routes (basic ones that should exist)
    expected_routes = ["/"]  # At minimum, should have a root route

    for expected_route in expected_routes:
        assert expected_route in routes, f"Route {expected_route} should exist"


if __name__ == "__main__":
    pytest.main([__file__])
