di = require('dinode').construct()

di.registerFile('navigation', 'scripts/modules/navigation')
di.registerFile('disqus', 'scripts/modules/disqus')
di.registerFile('tools', 'scripts/modules/tools')
di.registerFile('loadScript', 'scripts/modules/loadScript')
di.registerFile('historyWrapper', 'scripts/modules/historyWrapper')
di.registerFile('showPage', 'scripts/modules/showPage')
di.registerFile('unilytics', 'scripts/modules/unilytics')
di.registerFile('tracking', 'scripts/modules/tracking')

di.registerRequire('jQuery', 'commonjs-jquery')

di.registerVar('window', window)
di.registerVar('document', window.document)
di.registerVar('location', window.location)
di.registerVar('history', window.history)
di.registerVar('analytics', window.analytics)

di.registerAlias('$', 'jQuery')
