'''
	@inv raise_amt != null
'''

class Employee:
    raise_amt= 1.04
	
	'''
		@pre first != null, last != null, age != null and age > 0, pay !=null and pay > 0
		@post employee object has created.
	'''
    def __init__(self,first, last, age, pay):
        self.first= first
        self.last= last
		self.age = age
        self.pay= pay  
        
    @property      
    def full_name(self):
        return self.first+' '+self.last
		
    '''
		@pre full != null
		@post first = full.split[0] , last = full.split[1]
	'''
    @full_name.setter 
    def full_name(self, full):
        self.first, self.last= full.split()

	'''
		@post self.pay > 0 
	'''
    def apply_raise(self):
        self.pay= self.pay * self.raise_amt

        
