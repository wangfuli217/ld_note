#ifndef AREF_HPP
#define AREF_HPP

#include "Interfaces.hpp"

#include "AReference.hpp"
#include "Map.hpp"

class ARef : public AReference, public IRef, std::enable_shared_from_this<ARef> {
	public:
		ARef() : validator(NULL), watches(LMap::EMPTY) {};

		virtual void setValidator(std::shared_ptr<const IFn>);
		virtual std::shared_ptr<const IFn> getValidator();
		virtual std::shared_ptr<const IMap> getWatches();
		virtual std::shared_ptr<IRef> addWatch(std::shared_ptr<const lisp_object>, std::shared_ptr<const IFn>);
		virtual std::shared_ptr<IRef> removeWatch(std::shared_ptr<const lisp_object>);
		void notifyWatches(std::shared_ptr<const lisp_object> oldval, std::shared_ptr<const lisp_object> newval);
	protected:
		std::shared_ptr<const IFn> validator;
	private:
		std::shared_ptr<const IMap> watches;

		void validate(std::shared_ptr<const IFn>, std::shared_ptr<const lisp_object>);
};

#endif /* AREF_HPP */
