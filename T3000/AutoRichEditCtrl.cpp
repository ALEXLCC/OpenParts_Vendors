/ /   A u t o R i c h E d i t C t r l . c p p   :   i m p l e m e n t a t i o n   f i l e 
 / / 
 
 # i n c l u d e   " s t d a f x . h " 
 # i n c l u d e   " T 3 0 0 0 . h " 
 # i n c l u d e   " A u t o R i c h E d i t C t r l . h " 
 
 # i f d e f   _ D E B U G 
 # d e f i n e   n e w   D E B U G _ N E W 
 # u n d e f   T H I S _ F I L E 
 s t a t i c   c h a r   T H I S _ F I L E [ ]   =   _ _ F I L E _ _ ; 
 # e n d i f 
 
 / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / 
 / /   C A u t o R i c h E d i t C t r l 
 
 C A u t o R i c h E d i t C t r l : : C A u t o R i c h E d i t C t r l ( ) 
 { 
 } 
 
 C A u t o R i c h E d i t C t r l : : ~ C A u t o R i c h E d i t C t r l ( ) 
 { 
 } 
 
 
 B E G I N _ M E S S A G E _ M A P ( C A u t o R i c h E d i t C t r l ,   C R i c h E d i t C t r l ) 
 	 / / { { A F X _ M S G _ M A P ( C A u t o R i c h E d i t C t r l ) 
 	 	 / /   N O T E   -   t h e   C l a s s W i z a r d   w i l l   a d d   a n d   r e m o v e   m a p p i n g   m a c r o s   h e r e . 
 	 / / } } A F X _ M S G _ M A P 
 E N D _ M E S S A G E _ M A P ( ) 
 v o i d   C A u t o R i c h E d i t C t r l : : S e t S e l e c t T e x t C o l o r ( C O L O R R E F   c o l o r ) 
 { 
 	 C S t r i n g   f l o a t s t r n u m b e r ; 
 	 G e t W i n d o w T e x t ( f l o a t s t r n u m b e r ) ; 
 	 S e t S e l ( 0 , f l o a t s t r n u m b e r . G e t L e n g t h ( ) ) ; 
 	 C H A R F O R M A T   c f   =   G e t C h a r F o r m a t ( ) ; 
 
 	 i f   ( c f . d w E f f e c t s   &   C F E _ A U T O C O L O R )   c f . d w E f f e c t s   - =   C F E _ A U T O C O L O R ; 
 	 c f . c r T e x t C o l o r   = c o l o r ; 
 	 c f . d w M a s k   =   C F M _ C O L O R ; 
 
 
 	 S e t S e l e c t i o n C h a r F o r m a t ( c f ) ; 
 } 
 / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / / 
 / /   C A u t o R i c h E d i t C t r l   m e s s a g e   h a n d l e r s 
 v o i d   C A u t o R i c h E d i t C t r l : : F i e l d T e x t ( L P C T S T R   l p s z S t r i n g ) { 
 	 / * _ _ s u p e r : : S e t W i n d o w T e x t ( l p s z S t r i n g ) ; * / 
 	 S e t W i n d o w T e x t ( l p s z S t r i n g ) ; 
 	 S e t N u m b e r D e f a u l t T e x ( ) ; 
 
 } 
 v o i d   C A u t o R i c h E d i t C t r l : : F i e l d T e x t ( C O L O R R E F   r c f , L P C T S T R   l p s z S t r i n g ) { 
 	 / * _ _ s u p e r : : S e t W i n d o w T e x t ( l p s z S t r i n g ) ; * / 
 	 S e t W i n d o w T e x t ( l p s z S t r i n g ) ; 
 	 S e t N u m b e r D e f a u l t T e x ( r c f ) ; 
 
 } 
 C S t r i n g   C A u t o R i c h E d i t C t r l : : G e t R T F ( ) 
 { 
 	 / /   R e t u r n   t h e   R T F   s t r i n g   o f   t h e   t e x t   i n   t h e   c o n t r o l . 
 	 
 	 / /   S t r e a m   o u t   h e r e . 
 	 E D I T S T R E A M   e s ; 
 	 e s . d w E r r o r   =   0 ; 
 	 e s . p f n C a l l b a c k   =   C B S t r e a m O u t ; 	 	 / /   S e t   t h e   c a l l b a c k 
 
 	 C S t r i n g   s R T F   =   _ T ( " " ) ; 
 
 	 e s . d w C o o k i e   =   ( D W O R D )   & s R T F ; 	 / /   s o   s R T F   r e c e i v e s   t h e   s t r i n g 
 	 
 	 S t r e a m O u t ( S F _ R T F ,   e s ) ; 	 	 	 / /   C a l l   C R i c h E d i t C t r l : : S t r e a m O u t   t o   g e t   t h e   s t r i n g . 
 	 / / / 
 
 	 r e t u r n   s R T F ; 
 
 } 
 
 v o i d   C A u t o R i c h E d i t C t r l : : S e t R T F ( C S t r i n g   s R T F ) 
 { 
 	 / /   P u t   t h e   R T F   s t r i n g   s R T F   i n t o   t h e   r i c h   e d i t   c o n t r o l . 
 
 	 / /   R e a d   t h e   t e x t   i n 
 	 E D I T S T R E A M   e s ; 
 	 e s . d w E r r o r   =   0 ; 
 	 e s . p f n C a l l b a c k   =   C B S t r e a m I n ; 
 	 e s . d w C o o k i e   =   ( D W O R D )   & s R T F ; 
 	 S t r e a m I n ( S F _ R T F ,   e s ) ; 	 / /   D o   i t . 
 	 
 } 
 
 / * 
 	 C a l l b a c k   f u n c t i o n   t o   s t r e a m   a n   R T F   s t r i n g   i n t o   t h e   r i c h   e d i t   c o n t r o l . 
 * / 
 D W O R D   C A L L B A C K   C A u t o R i c h E d i t C t r l : : C B S t r e a m I n ( D W O R D   d w C o o k i e ,   L P B Y T E   p b B u f f ,   L O N G   c b ,   L O N G   * p c b ) 
 { 
 	 / /   W e   i n s e r t   t h e   r i c h   t e x t   h e r e . 
 
 / * 	 
 	 T h i s   f u n c t i o n   t a k e n   f r o m   C o d e G u r u . c o m 
 	 h t t p : / / w w w . c o d e g u r u . c o m / r i c h e d i t / r t f _ s t r i n g _ s t r e a m i n . s h t m l 
 	 Z a f i r   A n j u m 
 * / 
 
 	 C S t r i n g   * p s t r   =   ( C S t r i n g   * )   d w C o o k i e ; 
 
 	 i f   ( p s t r - > G e t L e n g t h ( )   <   c b ) 
 	 { 
 	 	 * p c b   =   p s t r - > G e t L e n g t h ( ) ; 
 	 	 m e m c p y ( p b B u f f ,   ( L P C S T R )   * p s t r - > G e t B u f f e r ( ) ,   * p c b ) ; 
 	 	 p s t r - > E m p t y ( ) ; 
 	 } 
 	 e l s e 
 	 { 
 	 	 * p c b   =   c b ; 
 	 	 m e m c p y ( p b B u f f ,   ( L P C S T R )   * p s t r - > G e t B u f f e r ( ) ,   * p c b ) ; 
 	 	 * p s t r   =   p s t r - > R i g h t ( p s t r - > G e t L e n g t h ( )   -   c b ) ; 
 	 } 
 	 / / / 
 
 	 r e t u r n   0 ; 
 } 
 
 / * 
 	 C a l l b a c k   f u n c t i o n   t o   s t r e a m   t h e   R T F   s t r i n g   o u t   o f   t h e   r i c h   e d i t   c o n t r o l . 
 * / 
 D W O R D   C A L L B A C K   C A u t o R i c h E d i t C t r l : : C B S t r e a m O u t ( D W O R D   d w C o o k i e ,   L P B Y T E   p b B u f f ,   L O N G   c b ,   L O N G   * p c b ) 
 { 
 	 / /   A d d r e s s   o f   o u r   s t r i n g   v a r   i s   i n   p s E n t r y 
 	 C S t r i n g   * p s E n t r y   =   ( C S t r i n g * )   d w C o o k i e ; 
 	 
 
 	 C S t r i n g   t m p E n t r y   =   _ T ( " " ) ; 
 	 t m p E n t r y   =   ( C S t r i n g )   p b B u f f ; 
 
 	 / /   A n d   w r i t e   i t ! ! ! 
 	 * p s E n t r y   + =   t m p E n t r y . L e f t ( c b ) ; 
 
 	 r e t u r n   0 ; 
 } 
 
 b o o l   C A u t o R i c h E d i t C t r l : : S e l e c t i o n I s B o l d ( ) 
 { 
 	 C H A R F O R M A T   c f   =   G e t C h a r F o r m a t ( ) ; 	 
 	 
 	 i f   ( c f . d w E f f e c t s   &   C F M _ B O L D ) 
 	 	 r e t u r n   t r u e ; 
 	 e l s e 
 	 	 r e t u r n   f a l s e ; 
 } 
 
 b o o l   C A u t o R i c h E d i t C t r l : : S e l e c t i o n I s I t a l i c ( ) 
 { 
 	 C H A R F O R M A T   c f   =   G e t C h a r F o r m a t ( ) ; 	 
 	 
 	 i f   ( c f . d w E f f e c t s   &   C F M _ I T A L I C ) 
 	 	 r e t u r n   t r u e ; 
 	 e l s e 
 	 	 r e t u r n   f a l s e ; 
 } 
 
 b o o l   C A u t o R i c h E d i t C t r l : : S e l e c t i o n I s U n d e r l i n e d ( ) 
 { 
 	 C H A R F O R M A T   c f   =   G e t C h a r F o r m a t ( ) ; 	 
 	 
 	 i f   ( c f . d w E f f e c t s   &   C F M _ U N D E R L I N E ) 
 	 	 r e t u r n   t r u e ; 
 	 e l s e 
 	 	 r e t u r n   f a l s e ; 
 } 
 
 C H A R F O R M A T   C A u t o R i c h E d i t C t r l : : G e t C h a r F o r m a t ( D W O R D   d w M a s k ) 
 { 
 	 C H A R F O R M A T   c f ; 
 	 c f . c b S i z e   =   s i z e o f ( C H A R F O R M A T ) ; 
 
 	 c f . d w M a s k   =   d w M a s k ; 
 
 	 G e t S e l e c t i o n C h a r F o r m a t ( c f ) ; 
 
 	 r e t u r n   c f ; 
 } 
 
 v o i d   C A u t o R i c h E d i t C t r l : : S e t C h a r S t y l e ( i n t   M A S K ,   i n t   S T Y L E ,   i n t   n S t a r t ,   i n t   n E n d ) 
 { 
 	 C H A R F O R M A T   c f ; 
 	 c f . c b S i z e   =   s i z e o f ( C H A R F O R M A T ) ; 
 	 / / c f . d w M a s k   =   M A S K ; 
 	 
 	 G e t S e l e c t i o n C h a r F o r m a t ( c f ) ; 
 	 
 	 i f   ( c f . d w M a s k   &   M A S K ) 	 / /   s e l e c t i o n   i s   a l l   t h e   s a m e 
 	 { 
 	 	 c f . d w E f f e c t s   ^ =   S T Y L E ;   
 	 } 
 	 e l s e 
 	 { 
 	 	 c f . d w E f f e c t s   | =   S T Y L E ; 
 	 } 
 	 
 	 c f . d w M a s k   =   M A S K ; 
 
 	 S e t S e l e c t i o n C h a r F o r m a t ( c f ) ; 
 
 } 
 
 v o i d   C A u t o R i c h E d i t C t r l : : S e t S e l e c t i o n B o l d ( ) 
 { 
 	 l o n g   s t a r t = 0 ,   e n d = 0 ; 
 	 G e t S e l ( s t a r t ,   e n d ) ; 	 	 / /   G e t   t h e   c u r r e n t   s e l e c t i o n 
 
 	 S e t C h a r S t y l e ( C F M _ B O L D ,   C F E _ B O L D ,   s t a r t ,   e n d ) ; 	 / /   M a k e   i t   b o l d 
 } 
 
 v o i d   C A u t o R i c h E d i t C t r l : : S e t S e l e c t i o n I t a l i c ( ) 
 { 
 	 l o n g   s t a r t = 0 ,   e n d = 0 ; 
 	 G e t S e l ( s t a r t ,   e n d ) ; 
 
 	 S e t C h a r S t y l e ( C F M _ I T A L I C ,   C F E _ I T A L I C ,   s t a r t ,   e n d ) ; 
 } 
 
 v o i d   C A u t o R i c h E d i t C t r l : : S e t S e l e c t i o n U n d e r l i n e d ( ) 
 { 
 	 l o n g   s t a r t = 0 ,   e n d = 0 ; 
 	 G e t S e l ( s t a r t ,   e n d ) ; 
 
 	 S e t C h a r S t y l e ( C F M _ U N D E R L I N E ,   C F E _ U N D E R L I N E ,   s t a r t ,   e n d ) ; 
 } 
 
 v o i d   C A u t o R i c h E d i t C t r l : : S e t P a r a g r a p h C e n t e r ( ) 
 { 
 	 P A R A F O R M A T   p a r a F o r m a t ;         
 	 p a r a F o r m a t . c b S i z e   =   s i z e o f ( P A R A F O R M A T ) ; 
 	 p a r a F o r m a t . d w M a s k   =   P F M _ A L I G N M E N T ;         
 	 p a r a F o r m a t . w A l i g n m e n t   =   P F A _ C E N T E R ; 
 	 
 	 S e t P a r a F o r m a t ( p a r a F o r m a t ) ; 	 / /   S e t   t h e   p a r a g r a p h . 
 } 
 
 v o i d   C A u t o R i c h E d i t C t r l : : S e t P a r a g r a p h L e f t ( ) 
 { 
 	 P A R A F O R M A T   p a r a F o r m a t ; 
 	 p a r a F o r m a t . c b S i z e   =   s i z e o f ( P A R A F O R M A T ) ; 
 	 p a r a F o r m a t . d w M a s k   =   P F M _ A L I G N M E N T ;         
 	 p a r a F o r m a t . w A l i g n m e n t   =   P F A _ L E F T ; 
 	 
 	 S e t P a r a F o r m a t ( p a r a F o r m a t ) ; 
 } 
 
 v o i d   C A u t o R i c h E d i t C t r l : : S e t P a r a g r a p h R i g h t ( ) 
 { 
 	 P A R A F O R M A T   p a r a F o r m a t ; 
 	 p a r a F o r m a t . c b S i z e   =   s i z e o f ( P A R A F O R M A T ) ; 
 	 p a r a F o r m a t . d w M a s k   =   P F M _ A L I G N M E N T ;         
 	 p a r a F o r m a t . w A l i g n m e n t   =   P F A _ R I G H T ; 
 	 
 	 S e t P a r a F o r m a t ( p a r a F o r m a t ) ; 
 } 
 
 b o o l   C A u t o R i c h E d i t C t r l : : P a r a g r a p h I s C e n t e r e d ( ) 
 { 
 	 P A R A F O R M A T   p f   =   G e t P a r a g r a p h F o r m a t ( ) ; 
 
 	 i f   ( p f . w A l i g n m e n t   = =   P F A _ C E N T E R ) 
 	 	 r e t u r n   t r u e ; 
 	 e l s e 
 	 	 r e t u r n   f a l s e ; 
 } 
 
 b o o l   C A u t o R i c h E d i t C t r l : : P a r a g r a p h I s L e f t ( ) 
 { 
 	 P A R A F O R M A T   p f   =   G e t P a r a g r a p h F o r m a t ( ) ; 
 
 	 i f   ( p f . w A l i g n m e n t   = =   P F A _ L E F T ) 
 	 	 r e t u r n   t r u e ; 
 	 e l s e 
 	 	 r e t u r n   f a l s e ; 
 } 
 
 b o o l   C A u t o R i c h E d i t C t r l : : P a r a g r a p h I s R i g h t ( ) 
 { 
 	 P A R A F O R M A T   p f   =   G e t P a r a g r a p h F o r m a t ( ) ; 
 
 	 i f   ( p f . w A l i g n m e n t   = =   P F A _ R I G H T ) 
 	 	 r e t u r n   t r u e ; 
 	 e l s e 
 	 	 r e t u r n   f a l s e ; 
 } 
 
 P A R A F O R M A T   C A u t o R i c h E d i t C t r l : : G e t P a r a g r a p h F o r m a t ( ) 
 { 
 	 P A R A F O R M A T   p f ; 
 	 p f . c b S i z e   =   s i z e o f ( P A R A F O R M A T ) ; 
 
 	 p f . d w M a s k   =   P F M _ A L I G N M E N T   |   P F M _ N U M B E R I N G ;         	 
 
 	 G e t P a r a F o r m a t ( p f ) ; 
 
 	 r e t u r n   p f ; 
 } 
 
 v o i d   C A u t o R i c h E d i t C t r l : : S e t P a r a g r a p h B u l l e t e d ( ) 
 { 
 	 P A R A F O R M A T   p a r a f o r m a t   =   G e t P a r a g r a p h F o r m a t ( ) ; 
 
 	 i f   (   ( p a r a f o r m a t . d w M a s k   &   P F M _ N U M B E R I N G )   & &   ( p a r a f o r m a t . w N u m b e r i n g   = =   P F N _ B U L L E T )   ) 
 	 { 
 	 	 p a r a f o r m a t . w N u m b e r i n g   =   0 ; 
 	 	 p a r a f o r m a t . d x O f f s e t   =   0 ; 
 	 	 p a r a f o r m a t . d x S t a r t I n d e n t   =   0 ; 
 	 	 p a r a f o r m a t . d w M a s k   =   P F M _ N U M B E R I N G   |   P F M _ S T A R T I N D E N T   |   P F M _ O F F S E T ; 
 	 } 
 	 e l s e 
 	 { 
 	 	 p a r a f o r m a t . w N u m b e r i n g   =   P F N _ B U L L E T ; 
 	 	 p a r a f o r m a t . d w M a s k   =   P F M _ N U M B E R I N G ; 
 	 	 i f   ( p a r a f o r m a t . d x O f f s e t   = =   0 ) 
 	 	 { 
 	 	 	 p a r a f o r m a t . d x O f f s e t   =   4 ; 
 	 	 	 p a r a f o r m a t . d w M a s k   =   P F M _ N U M B E R I N G   |   P F M _ S T A R T I N D E N T   |   P F M _ O F F S E T ; 
 	 	 } 
 	 } 
 	 
 	 S e t P a r a F o r m a t ( p a r a f o r m a t ) ; 
 
 } 
 
 b o o l   C A u t o R i c h E d i t C t r l : : P a r a g r a p h I s B u l l e t e d ( ) 
 { 
 	 P A R A F O R M A T   p f   =   G e t P a r a g r a p h F o r m a t ( ) ; 
 
 	 i f   ( p f . w N u m b e r i n g   = =   P F N _ B U L L E T ) 
 	 	 r e t u r n   t r u e ; 
 	 e l s e 
 	 	 r e t u r n   f a l s e ; 
 } 
 
 v o i d   C A u t o R i c h E d i t C t r l : : S e l e c t C o l o r ( ) 
 { 
 	 C C o l o r D i a l o g   d l g ; 
 
 	 C H A R F O R M A T   c f   =   G e t C h a r F o r m a t ( ) ; 
 
 	 i f   ( c f . d w E f f e c t s   &   C F E _ A U T O C O L O R )   c f . d w E f f e c t s   - =   C F E _ A U T O C O L O R ; 
 
 	 / /   G e t   a   c o l o r   f r o m   t h e   c o m m o n   c o l o r   d i a l o g . 
 	 i f (   d l g . D o M o d a l ( )   = =   I D O K   ) 
 	 { 	 
 	 	 c f . c r T e x t C o l o r   =   d l g . G e t C o l o r ( ) ; 
 	 } 
 
 	 c f . d w M a s k   =   C F M _ C O L O R ; 
 
 	 S e t S e l e c t i o n C h a r F o r m a t ( c f ) ; 
 } 
 
 v o i d   C A u t o R i c h E d i t C t r l : : S e t F o n t N a m e ( C S t r i n g   s F o n t N a m e ) 
 { 
 	 C H A R F O R M A T   c f   =   G e t C h a r F o r m a t ( ) ; 
 
 	 / /   S e t   t h e   f o n t   n a m e . 
 	 f o r   ( i n t   i   =   0 ;   i   < =   s F o n t N a m e . G e t L e n g t h ( ) - 1 ;   i + + ) 
 	 	 c f . s z F a c e N a m e [ i ]   =   s F o n t N a m e [ i ] ; 
 
 
 	 c f . d w M a s k   =   C F M _ F A C E ; 
 
 	 S e t S e l e c t i o n C h a r F o r m a t ( c f ) ; 
 } 
 
 v o i d   C A u t o R i c h E d i t C t r l : : S e t F o n t S i z e ( i n t   n P o i n t S i z e ) 
 { 
 	 C S t r i n g   f l o a t s t r n u m b e r ; 
 	 i n t   s i z e = n P o i n t S i z e ; 
 	 G e t W i n d o w T e x t ( f l o a t s t r n u m b e r ) ; 
 	 S e t S e l ( 0 , f l o a t s t r n u m b e r . G e t L e n g t h ( ) ) ; 
 	 C H A R F O R M A T   c f   =   G e t C h a r F o r m a t ( ) ; 
 
 	 n P o i n t S i z e   * =   2 0 ; 	 / /   c o n v e r t   f r o m   t o   t w i p s 
 	 c f . y H e i g h t   =   n P o i n t S i z e ; 
 	 
 	 c f . d w M a s k   =   C F M _ S I Z E ; 
 
 	 S e t S e l e c t i o n C h a r F o r m a t ( c f ) ; 
 } 
 v o i d   C A u t o R i c h E d i t C t r l : : S e t N u m b e r D e f a u l t F o n t S i z e ( i n t   n P o i n t S i z e ) 
 { 
 	 C S t r i n g   f l o a t s t r n u m b e r ; 
 	 i n t   s i z e = n P o i n t S i z e ; 
 	 G e t W i n d o w T e x t ( f l o a t s t r n u m b e r ) ; 
 	 i n t   i n d e x = f l o a t s t r n u m b e r . F i n d ( _ T ( " . " ) ) ; 
 	 i n t   l e n = f l o a t s t r n u m b e r . G e t L e n g t h ( ) ; 
 	 i f   ( i n d e x ! = - 1 ) 
 	 { 
 	 	 S e t S e l ( 0 , i n d e x ) ; 
 	 	 C H A R F O R M A T   c f   =   G e t C h a r F o r m a t ( ) ; 
 	 	 n P o i n t S i z e   * =   2 0 ; 	 / /   c o n v e r t   f r o m   t o   t w i p s 
 	 	 c f . y H e i g h t   =   n P o i n t S i z e ; 
 	 	 c f . d w M a s k   =   C F M _ S I Z E ; 
 	 	 S e t S e l e c t i o n C h a r F o r m a t ( c f ) ; 
 	 	 S e t S e l ( i n d e x , l e n ) ; 
 	 	     c f   =   G e t C h a r F o r m a t ( ) ; 
 	 	 n P o i n t S i z e = s i z e - 3 ; 
 	 	 n P o i n t S i z e * = 2 0 ; 	 / /   c o n v e r t   f r o m   t o   t w i p s 
 	 	 c f . y H e i g h t   =   n P o i n t S i z e ; 
 	 	 c f . d w M a s k   =   C F M _ S I Z E ; 
 	 	 S e t S e l e c t i o n C h a r F o r m a t ( c f ) ; 
 	 } 
 	 
 } 
 v o i d   C A u t o R i c h E d i t C t r l : : S e t N u m b e r D e f a u l t T e x ( C O L O R R E F   c r f ) 
 {       i n t   n P o i n t S i z e = 1 1 ; 
 	 C S t r i n g   f l o a t s t r n u m b e r ; 
 	 i n t   s i z e = n P o i n t S i z e ; 
 	 G e t W i n d o w T e x t ( f l o a t s t r n u m b e r ) ; 
 	 i n t   i n d e x = f l o a t s t r n u m b e r . F i n d ( _ T ( " . " ) ) ; 
 	 i n t   l e n = f l o a t s t r n u m b e r . G e t L e n g t h ( ) ; 
 	 i f   ( i n d e x ! = - 1 ) 
 	 { 
   	 	 S e t S e l ( 0 , l e n ) ; 
   	 	 C H A R F O R M A T   c f   =   G e t C h a r F o r m a t ( ) ; 
   	 	 n P o i n t S i z e   * =   2 0 ; 	 / /   c o n v e r t   f r o m   t o   t w i p s 
 	 	 c f . c r T e x t C o l o r = R G B ( 0 , 0 , 0 ) ; 
   	 	 c f . y H e i g h t   =   n P o i n t S i z e ; 
   	 	 c f . d w M a s k   =   C F M _ S I Z E ; 
 	 	   
 	 	 / / s t r c p y ( c f . s z F a c e N a m e   , _ T ( " A r i a l " ) ) ; / / � � � � � � � � 
 	 	 m e m c p y ( & c f . s z F a c e N a m e , " A r i a l " , s i z e o f ( c f . s z F a c e N a m e ) ) ; 
   	 	 S e t S e l e c t i o n C h a r F o r m a t ( c f ) ; 
 
   	 	 S e t S e l ( i n d e x , l e n ) ; 
   	 	 c f   =   G e t C h a r F o r m a t ( ) ; 
   	 	 n P o i n t S i z e = s i z e - 4 ; 
   	 	 n P o i n t S i z e * = 2 0 ; 	 / /   c o n v e r t   f r o m   t o   t w i p s 
   	 	 c f . y H e i g h t   =   n P o i n t S i z e ; 
   	 	 c f . d w M a s k   =   C F M _ S I Z E ; 
   	 	 S e t S e l e c t i o n C h a r F o r m a t ( c f ) ; 
 
 
     	 	 S e t S e l ( i n d e x + 2 , l e n ) ; 
     	 	   c f   =   G e t C h a r F o r m a t ( ) ; 
 	 	   n P o i n t S i z e = s i z e ; 
     	 	 n P o i n t S i z e   * =   2 0 ; 	 / /   c o n v e r t   f r o m   t o   t w i p s 
     	 	 c f . y H e i g h t   =   n P o i n t S i z e ; 
 	 	 c f . c r T e x t C o l o r = R G B ( 0 , 0 , 0 ) ; 
 	 	 m e m c p y ( & c f . s z F a c e N a m e , " A r i a l " , s i z e o f ( c f . s z F a c e N a m e ) ) ; 
     	 	 c f . d w M a s k   =   C F M _ S I Z E ; 
     	 	 S e t S e l e c t i o n C h a r F o r m a t ( c f ) ; 
 	 } 
 	 e l s e 
 	 { 
 	 	 S e t S e l ( 0 , l e n ) ; 
 	 	 C H A R F O R M A T   c f   =   G e t C h a r F o r m a t ( ) ; 
 	 	 n P o i n t S i z e   * =   2 0 ; 	 / /   c o n v e r t   f r o m   t o   t w i p s 
 	 	 c f . y H e i g h t   =   n P o i n t S i z e ; 
 	 	 c f . d w M a s k   =   C F M _ S I Z E ; 
 	 	 c f . c r T e x t C o l o r = R G B ( 0 , 0 , 0 ) ; 
 	 	 m e m c p y ( & c f . s z F a c e N a m e , " A r i a l " , s i z e o f ( c f . s z F a c e N a m e ) ) ; 
 	 	 S e t S e l e c t i o n C h a r F o r m a t ( c f ) ; 
 	 } 
 	 S e t S e l ( 0 , l e n ) ; 
 	   
 	   
 	   
 	 C H A R F O R M A T   c f   =   G e t C h a r F o r m a t ( ) ; 
 
 	 i f   ( c f . d w E f f e c t s   &   C F E _ A U T O C O L O R )   c f . d w E f f e c t s   - =   C F E _ A U T O C O L O R ; 
 	 c f . c r T e x t C o l o r   = c r f ; 
 	 c f . c r T e x t C o l o r = R G B ( 0 , 0 , 0 ) ; 
 	 c f . d w M a s k   =   C F M _ C O L O R ; 
 
 	 S e t S e l e c t i o n C h a r F o r m a t ( c f ) ; 
 } 
 
 v o i d   C A u t o R i c h E d i t C t r l : : G e t S y s t e m F o n t s ( C S t r i n g A r r a y   & s a F o n t L i s t ) 
 { 
 	 C D C   * p D C   =   G e t D C   ( ) ; 
 
 	 E n u m F o n t s   ( p D C - > G e t S a f e H d c ( ) , N U L L , ( F O N T E N U M P R O C )   C B E n u m F o n t s , ( L P A R A M ) & s a F o n t L i s t ) ; / / E n u m e r a t e 
 
 } 
 
 B O O L   C A L L B A C K   C A u t o R i c h E d i t C t r l : : C B E n u m F o n t s ( L P L O G F O N T   l p l f ,   L P T E X T M E T R I C   l p t m ,   D W O R D   d w T y p e ,   L P A R A M   l p D a t a ) 
 { 
 	 / /   T h i s   f u n c t i o n   w a s   w r i t t e n   w i t h   t h e   h e l p   o f   C C u s t C o m b o B o x ,   b y   G i r i s h   B h a r a d w a j . 
 	 / /   A v a i l a b l e   f r o m   C o d e g u r u . 
 
 	 i f   ( d w T y p e   = =   T R U E T Y P E _ F O N T T Y P E )   
 	 { 
 	 	 ( ( C S t r i n g A r r a y   * )   l p D a t a ) - > A d d (   l p l f - > l f F a c e N a m e   ) ; 
 	 } 
 
 	 r e t u r n   t r u e ; 
 } 
 
 C S t r i n g   C A u t o R i c h E d i t C t r l : : G e t S e l e c t i o n F o n t N a m e ( ) 
 { 
 	 C H A R F O R M A T   c f   =   G e t C h a r F o r m a t ( ) ; 
 
 	 C S t r i n g   s N a m e   =   c f . s z F a c e N a m e ; 
 
 	 r e t u r n   s N a m e ; 
 } 
 
 l o n g   C A u t o R i c h E d i t C t r l : : G e t S e l e c t i o n F o n t S i z e ( ) 
 { 
 	 C H A R F O R M A T   c f   =   G e t C h a r F o r m a t ( ) ; 
 
 	 l o n g   n S i z e   =   c f . y H e i g h t / 2 0 ; 
 
 	 r e t u r n   n S i z e ; 
 } 
 