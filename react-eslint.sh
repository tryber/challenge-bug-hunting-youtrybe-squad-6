#!/bin/bash

# ----------------------
# Color Variables
# ----------------------
RED="\033[0;31m"
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
LCYAN='\033[1;36m'
NC='\033[0m' # No Color

# --------------------------------------
# Prompts for configuration preferences
# --------------------------------------

# Package Manager Prompt
echo
echo "Which package manager are you using?"
select package_command_choices in "Yarn" "npm" "Cancel"; do
  case $package_command_choices in
    Yarn ) pkg_cmd='yarn add'; break;;
    npm ) pkg_cmd='npm install'; break;;
    Cancel ) exit;;
  esac
done
echo

# File Format Prompt
echo "Which ESLint and Prettier configuration format do you prefer?"
select config_extension in ".js" ".json" "Cancel"; do
  case $config_extension in
    .js ) config_opening='module.exports = {'; break;;
    .json ) config_opening='{'; break;;
    Cancel ) exit;;
  esac
done
echo

# Checks for existing eslintrc files
if [ -f ".eslintrc.js" -o -f ".eslintrc.yaml" -o -f ".eslintrc.yml" -o -f ".eslintrc.json" -o -f ".eslintrc" ]; then
  echo -e "${RED}Existing ESLint config file(s) found:${NC}"
  ls -a .eslint* | xargs -n 1 basename
  echo
  echo -e "${RED}CAUTION:${NC} there is loading priority when more than one config file is present: https://eslint.org/docs/user-guide/configuring#configuration-file-formats"
  echo
  read -p  "Write .eslintrc${config_extension} (Y/n)? "
  if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo -e "${YELLOW}>>>>> Skipping ESLint config${NC}"
    skip_eslint_setup="true"
  fi
fi
finished=false

# Checks for existing stylelint files
if [ -f ".stylelintrc.js" -o -f ".stylelintrc.yaml" -o -f ".stylelintrc.yml" -o -f ".stylelintrc.json" -o -f ".stylelintrc" ]; then
  echo -e "${RED}Existing Stylelint config file(s) found:${NC}"
  ls -a .stylelint* | xargs -n 1 basename
  echo
  echo -e "${RED}CAUTION:${NC} there is loading priority when more than one config file is present"
  echo
  read -p  "Write .stylelintrc${config_extension} (Y/n)? "
  if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo -e "${YELLOW}>>>>> Skipping Stylelint config${NC}"
    skip_stylelint_setup="true"
  fi
fi
finished=false

# Max Line Length Prompt
while ! $finished; do
  read -p "What max line length do you want to set for ESLint and Prettier? (Recommendation: 80)"
  if [[ $REPLY =~ ^[0-9]{2,3}$ ]]; then
    max_len_val=$REPLY
    finished=true
    echo
  else
    echo -e "${YELLOW}Please choose a max length of two or three digits, e.g. 80 or 100 or 120${NC}"
  fi
done

# Trailing Commas Prompt
echo "What style of trailing commas do you want to enforce with Prettier?"
echo -e "${YELLOW}>>>>> See https://prettier.io/docs/en/options.html#trailing-commas for more details.${NC}"
select trailing_comma_pref in "none" "es5" "all"; do
  case $trailing_comma_pref in
    none ) break;;
    es5 ) break;;
    all ) break;;
  esac
done
echo

# Checks for existing prettierrc files
if [ -f ".prettierrc.js" -o -f "prettier.config.js" -o -f ".prettierrc.yaml" -o -f ".prettierrc.yml" -o -f ".prettierrc.json" -o -f ".prettierrc.toml" -o -f ".prettierrc" ]; then
  echo -e "${RED}Existing Prettier config file(s) found${NC}"
  ls -a | grep "prettier*" | xargs -n 1 basename
  echo
  echo -e "${RED}CAUTION:${NC} The configuration file will be resolved starting from the location of the file being formatted, and searching up the file tree until a config file is (or isn't) found. https://prettier.io/docs/en/configuration.html"
  echo
  read -p  "Write .prettierrc${config_extension} (Y/n)? "
  if [[ $REPLY =~ ^[Nn]$ ]]; then
    echo -e "${YELLOW}>>>>> Skipping Prettier config${NC}"
    skip_prettier_setup="true"
  fi
  echo
fi

# ----------------------
# Perform Configuration
# ----------------------
echo
echo -e "${GREEN}Configuring your development environment... ${NC}"

echo
echo -e "1/6 ${LCYAN}ESLint & Prettier Installation... ${NC}"
echo
$pkg_cmd -D eslint@6.6.0 prettier stylelint

echo
echo -e "2/6 ${YELLOW}Conforming to Airbnb's JavaScript Style Guide... ${NC}"
echo
$pkg_cmd -D eslint-config-airbnb eslint-plugin-jsx-a11y eslint-plugin-import eslint-plugin-react babel-eslint stylelint-config-airbnb

echo
echo -e "3/6 ${LCYAN}Making ESlint, Stylelint and Prettier play nice with each other... ${NC}"
echo "See https://github.com/prettier/eslint-config-prettier for more details."
echo
$pkg_cmd -D eslint-config-prettier eslint-plugin-prettier stylelint-prettier stylelint-order stylelint-scss


if [ "$skip_eslint_setup" == "true" ]; then
  break
else
  echo
  echo -e "4/6 ${YELLOW}Building your .eslintrc${config_extension} file...${NC}"
  > ".eslintrc${config_extension}" # truncates existing file (or creates empty)

  echo ${config_opening}'
  "extends": [
    "airbnb",
    "plugin:prettier/recommended",
    "prettier/react"
  ],
  "env": {
    "browser": true,
    "commonjs": true,
    "es6": true,
    "jest": true,
    "node": true
  },
  "parser": "babel-eslint",
  "rules": {
    "jsx-a11y/href-no-hash": ["off"],
    "react/jsx-filename-extension": ["warn", { "extensions": [".js", ".jsx"] }],
    "max-len": [
      "warn",
      {
        "code": '${max_len_val}',
        "tabWidth": 2,
        "comments": '${max_len_val}',
        "ignoreComments": false,
        "ignoreTrailingComments": true,
        "ignoreUrls": true,
        "ignoreStrings": true,
        "ignoreTemplateLiterals": true,
        "ignoreRegExpLiterals": true
      }
    ]
  }
}' >> .eslintrc${config_extension}
fi


if [ "$skip_stylelint_setup" == "true" ]; then
  break
else
  echo
  echo -e "5/6 ${YELLOW}Building your .stylelintrc${config_extension} file...${NC}"
  > ".stylelintrc${config_extension}" # truncates existing file (or creates empty)

  echo ${config_opening}'
  "extends": "stylelint-config-airbnb",
  "plugins": ["stylelint-prettier", "stylelint-order"],
  "rules": {
    "order/properties-alphabetical-order": true,
    "prettier/prettier": true,
    "at-rule-empty-line-before": "always",
    "at-rule-name-case": "lower",
    "at-rule-name-space-after": "always",
    "at-rule-no-unknown": true,
    "at-rule-no-vendor-prefix": true,
    "at-rule-semicolon-newline-after": "always",
    "at-rule-semicolon-space-before": "always",
    "block-closing-brace-newline-after": "always",
    "block-no-empty": true,
    "block-opening-brace-space-after": "always-single-line",
    "block-opening-brace-space-before": "always",
    "color-hex-case": "lower",
    "color-hex-length": "short",
    "color-named": "always-where-possible",
    "color-no-invalid-hex": true,
    "comment-empty-line-before": "always",
    "comment-no-empty": true,
    "comment-whitespace-inside": "always",
    "custom-property-empty-line-before": "always",
    "declaration-bang-space-after": "always",
    "declaration-bang-space-before": "always",
    "declaration-block-no-duplicate-properties": true,
    "declaration-block-no-redundant-longhand-properties": true,
    "declaration-block-no-shorthand-property-overrides": true,
    "declaration-block-semicolon-newline-after": "always",
    "declaration-block-semicolon-newline-before": "never-multi-line",
    "declaration-block-semicolon-space-after": "always-single-line",
    "declaration-block-single-line-max-declarations": 1,
    "declaration-block-trailing-semicolon": "always",
    "declaration-colon-space-after": "always",
    "declaration-empty-line-before": "never",
    "declaration-no-important": true,
    "font-family-name-quotes": "always-where-required",
    "font-family-no-duplicate-names": true,
    "font-family-no-missing-generic-family-keyword": true,
    "font-weight-notation": "numeric",
    "function-calc-no-unspaced-operator": true,
    "function-comma-space-after": "always",
    "function-comma-space-before": "never",
    "function-linear-gradient-no-nonstandard-direction": true,
    "function-max-empty-lines": 0,
    "function-name-case": "lower",
    "function-parentheses-space-inside": "never",
    "function-url-no-scheme-relative": true,
    "function-url-quotes": "always",
    "function-whitespace-after": "always",
    "indentation": [
      2,
      {
        "baseIndentLevel": 1
      }
    ],
    "keyframe-declaration-no-important": true,
    "length-zero-no-unit": true,
    "linebreaks": "unix",
    "max-empty-lines": 2,
    "max-line-length": 90,
    "max-nesting-depth": 2,
    "media-feature-colon-space-after": "always",
    "media-feature-colon-space-before": "always",
    "media-feature-name-case": "lower",
    "media-feature-name-no-unknown": true,
    "media-feature-name-no-vendor-prefix": true,
    "media-feature-parentheses-space-inside": "always",
    "media-feature-range-operator-space-after": "always",
    "media-feature-range-operator-space-before": "always",
    "media-query-list-comma-space-after": "always",
    "media-query-list-comma-space-before": "always",
    "no-descending-specificity": true,
    "no-duplicate-at-import-rules": true,
    "no-duplicate-selectors": true,
    "no-empty-source": true,
    "no-empty-first-line": true,
    "no-eol-whitespace": true,
    "no-extra-semicolons": true,
    "no-invalid-double-slash-comments": true,
    "no-missing-end-of-source-newline": true,
    "no-unknown-animations": true,
    "number-leading-zero": "always",
    "number-max-precision": 3,
    "number-no-trailing-zeros": true,
    "property-case": "lower",
    "property-no-unknown": true,
    "property-no-vendor-prefix": true,
    "rule-empty-line-before": [
      "always",
      {
        "except": ["after-single-line-comment"]
      }
    ],
    "selector-attribute-brackets-space-inside": "always",
    "selector-attribute-operator-space-after": "always",
    "selector-attribute-operator-space-before": "always",
    "selector-attribute-quotes": "always",
    "selector-combinator-space-after": "always",
    "selector-combinator-space-before": "always",
    "selector-descendant-combinator-no-non-space": true,
    "selector-list-comma-space-after": "always",
    "selector-list-comma-space-before": "always",
    "selector-max-attribute": 3,
    "selector-max-class": 5,
    "selector-max-combinators": 3,
    "selector-max-compound-selectors": 5,
    "selector-max-empty-lines": 0,
    "selector-max-id": 5,
    "selector-max-pseudo-class": 3,
    "selector-max-type": 5,
    "selector-max-universal": 3,
    "selector-no-qualifying-type": true,
    "selector-no-vendor-prefix": true,
    "selector-pseudo-class-case": "lower",
    "selector-pseudo-class-no-unknown": true,
    "selector-pseudo-class-parentheses-space-inside": "always",
    "selector-pseudo-element-case": "lower",
    "selector-pseudo-element-colon-notation": "single",
    "selector-pseudo-element-no-unknown": true,
    "selector-type-case": "lower",
    "selector-type-no-unknown": true,
    "shorthand-property-no-redundant-values": true,
    "string-no-newline": true,
    "string-quotes": "single",
    "time-min-milliseconds": 100,
    "unit-case": "lower",
    "unit-no-unknown": true,
    "value-keyword-case": "lower",
    "value-list-comma-space-after": "always",
    "value-list-comma-space-before": "always",
    "value-list-max-empty-lines": 0,
    "value-no-vendor-prefix": true
  }
}' >> .stylelintrc${config_extension}
fi


if [ "$skip_prettier_setup" == "true" ]; then
  break
else
  echo -e "6/6 ${YELLOW}Building your .prettierrc${config_extension} file... ${NC}"
  > .prettierrc${config_extension} # truncates existing file (or creates empty)

  echo ${config_opening}'
  "printWidth": '${max_len_val}',
  "singleQuote": true,
  "trailingComma": "'${trailing_comma_pref}'"
}' >> .prettierrc${config_extension}
fi

echo
echo -e "${GREEN}Finished setting up!${NC}"
echo