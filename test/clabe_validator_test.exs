defmodule ClabeValidatorTest do
  use ExUnit.Case
  doctest ClabeValidator

  import ClabeValidator, only: [validate: 1]

  test "clabe is valid 1" do
    assert ClabeValidator.validate("137308102750430150") == true
  end

  test "clabe is valid 2" do
    assert ClabeValidator.validate("002180435001047924") == true
  end

end
