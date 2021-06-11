#include "ARef.hpp"

void ARef::setValidator(std::shared_ptr<const IFn> f) {
	  validate(f, deref());
	    validator = f;
}

std::shared_ptr<const IFn> ARef::getValidator() {
	  return validator;
}

std::shared_ptr<const IMap> ARef::getWatches() {
	  return watches;
}

std::shared_ptr<IRef> ARef::addWatch(std::shared_ptr<const lisp_object> key, std::shared_ptr<const IFn> callback) {
	  watches = std::dynamic_pointer_cast<const IMap>(watches->assoc(key, callback));
	    return std::dynamic_pointer_cast<IRef>(shared_from_this());
}

std::shared_ptr<IRef> ARef::removeWatch(std::shared_ptr<const lisp_object> key) {
	  watches = std::dynamic_pointer_cast<const IMap>(watches->without(key));
	    return std::dynamic_pointer_cast<IRef>(shared_from_this());
}

void ARef::notifyWatches(std::shared_ptr<const lisp_object> oldval, std::shared_ptr<const lisp_object> newval) {
	  std::shared_ptr<const IMap> ws = watches;
	    if(ws->count() > 0) {
			    for(std::shared_ptr<const ISeq> s = ws->seq(); s != NULL; s = s->next()) {
					      std::shared_ptr<const IMapEntry> e = std::dynamic_pointer_cast<const IMapEntry>(s->first());
						        std::shared_ptr<const IFn> f = std::dynamic_pointer_cast<const IFn>(e->val());
								      if(f)
										          f->invoke(e->key(), shared_from_this(), oldval, newval);
									      }
				  }
}

void ARef::validate(std::shared_ptr<const IFn> f, std::shared_ptr<const lisp_object> val) {
	  try {
		      if(f && !(bool)f->invoke(val))
				        throw std::runtime_error("Invalid reference state");
			    } catch(std::runtime_error e) {
					    throw e;
						  } catch(std::exception &e) {
							      throw std::runtime_error(std::string("Invalid reference state: ") + e.what());
								    }
}
