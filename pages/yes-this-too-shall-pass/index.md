title: Yes, This Too Shall Pass
date: 2007-06-01

Yesterday, IBM decided to change strategies with respect to GNOME accessibility: http://www-03.ibm.com/developerworks/blogs/page/schwer. Under this new plan, IBM is no longer supporting development of LSR, accerciser, pyatspi, AT-SPI::Collection, or Firefox/AT-SPI accessibility. These projects will not vanish, but the news does have an impact on each.

## Accerciser

Eitan Isaacson is busy preparing Accerciser for inclusion in GNOME 2.20 under a grant from the Mozilla Foundation. Its development and documentation is far enough along that it should only require minimal future maintenance (i.e. bug fixes, updates to stay in sync with at-spi). As far as I know, Eitan plans to stay on as maintainer of Accerciser after the grant concludes. Even if Eitan does decide to leave, someone from the accessibility or automated testing communities could step up and take ownership over the code.

## pyatspi

The Python bindings for AT-SPI are complete enough to power Accerciser today. Dogtail and LDTP are busy adopting them as well. Orca, as I understand it, plans to adopt them sometime in the GNOME 2.20 or 2.22 time frame. I will do my best to support pyatspi as problems arise until another member of the GNOME community is expert enough to own the binding. Since pyatspi is in the at-spi module, Li Yuan remains as the proper maintainer.

## LSR

Development on LSR as a screen reader for GNOME will cease. We will make one last release of LSR 0.5.3 on Monday in line with GNOME 2.19.3. After that, the project will go dormant until various groups decide whether the LSR core will be used to drive other open source AT projects or if it will be abandoned altogether. Over the next few weeks, I will be updating and writing documentation in case the LSR core goes on to live in other projects. I will also reorganize the LSR wiki to de-emphasize the screen reader user content, and put the focus more on developer documentation. Contact me directly if you wish to discuss LSR.

## Firefox and the Mozilla platform

Aaron Leventhal will remain the maintainer of accessibility for the Mozilla core. His priorities will now be: 1) ARIA support on Windows and Linux , 2) Firefox 3 accessibility regressions, 3) IAccessible2 and cross-platform issues.

Aaron will not be focusing on Linux accessibility support in the Firefox 3 timeframe unless it affects all platforms, API harmonization or ARIA support. The ATK/AT-SPI-specific support of XUL and HTML must now be via the existing community and module peers. Aaron will continue to be available to review bug fixes in those areas. Contact Aaron directly for details.

## AT-SPI Collection

Ariel Rios has (or will) post his outstanding work on implementing the AT-SPI Collection interface. I'm not sure of his immediate plans, but he has expressed an interest in completing the work on his personal time. Contact Ariel directly for details. Documentation about Collection can be found at http://live.gnome.org/GAP/Collection.

Personally, I am still extremely interested in accessibility and the GNOME desktop. The IBM decision means that I will no longer contribute to GNOME through my daily work, but I certainly plan to make contributions to GNOME as a hobbyist. In addition, I will gladly help anyone who wishes to develop or reuse any of the projects I worked on for the past two years. Feel free to contact me about them at any time.

Finally, I want to wish all the other accessibility developers on GNOME the best of luck. Keep fighting the good fight of making free software accessible to all those who want it.