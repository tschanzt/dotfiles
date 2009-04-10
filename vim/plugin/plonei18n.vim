
function! Jonei18n(...)
    !cat % | grep ' label\| description' | grep -v atapi > /tmp/plone.i18n.file.po
    split
    e /tmp/plone.i18n.file.po
    %s/^ *//g
    %s/ = /=/g
    %s/^\(label\|description\)='\(.*\)',$/#. Default "\2"/g
    %s/^\(label_msgid\|description_msgid\)='\(.*\)',$/msgid "\2"\rmsgstr ""\r/g
    write
    !cat % | pbcopy
    q
    !rm /tmp/plone.i18n.file.po
endfunction

