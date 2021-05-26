module Templates.Types where

-- | A wrapper around 'Text' for module names
newtype ModuleName = ModuleName Text

-- | A wrapper around 'Text' for template names
newtype TemplateName = TemplateName Text

-- | A wrapper around 'HashMap Text Text' for template assigns
newtype TemplateAssigns = TemplateAssigns { getAssigns :: HashMap Text Text }
