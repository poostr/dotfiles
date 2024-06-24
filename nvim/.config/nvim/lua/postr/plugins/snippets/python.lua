local ls = require("luasnip")

local s = ls.snippet
local i = ls.insert_node

local fmt = require("luasnip.extras.fmt").fmt

local test_class_snip = [[
import pytest
import allure

class Test{}:

    @pytest.fixture(scope="class")
    def user(self, users):
        return users.get_firm().Contact

    def test_{}(self, user, api):
    """
    """
    with allure.step():
        assert True
]]

local test_func = [[
    def test_{}(self, user, api):
    """

    """
    with allure.step():
        assert True

]]

ls.add_snippets("python", {
	s("als", fmt("with allure.step({})", { i(0) })),
	s("ass", fmt("assert True", {})),
	s("testcl", fmt(test_class_snip, { i(1), i(0) })),
	s("testf", fmt(test_func, { i(0) })),
})
